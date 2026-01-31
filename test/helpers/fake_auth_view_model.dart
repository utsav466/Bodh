import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    // initial state for tests
    return const AuthState();
  }

  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    String? phoneNumber,
  }) async {
    // do nothing
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // do nothing
  }

  @override
  Future<void> updateAvatar(dynamic image) async {
    // do nothing
  }
}
