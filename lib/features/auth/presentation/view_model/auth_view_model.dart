import 'dart:io';

import 'package:bodh_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/update_avatar_usecase.dart';
import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(() => AuthViewModel());

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final UpdateAvatarUsecase _updateAvatarUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _updateAvatarUsecase = ref.read(updateAvatarUsecaseProvider);
    return const AuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    String? phoneNumber,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
      successMessage: null,
    );

    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      password: password,
    );

    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          status: AuthStatus.registered,
          successMessage: "User registered successfully",
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
      successMessage: null,
    );

    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
          successMessage: "Login successful",
        );
      },
    );
  }

Future<void> updateAvatar(File image) async {
  state = state.copyWith(
    status: AuthStatus.loading,
    errorMessage: null,
    successMessage: null,
  );

  try {
    final result = await _updateAvatarUsecase(image);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message, // should be human readable
          successMessage: null,
        );
      },
      (updatedAuth) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: updatedAuth,
          successMessage: "Profile picture updated successfully",
          errorMessage: null,
        );
      },
    );
  } catch (_) {
    // ✅ Prevent "UnimplementedError" or raw exceptions from showing
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage: "Failed to update profile picture",
      successMessage: null,
    );
  }
}

}
