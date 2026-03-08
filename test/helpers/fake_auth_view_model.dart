import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
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
    // no-op for widget tests
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // no-op for widget tests
  }

  @override
  Future<void> updateAvatar(dynamic image) async {
    // no-op for widget tests
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    return {
      "success": true,
      "message": "Reset code sent successfully",
    };
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
  }) async {
    return {
      "success": true,
      "message": "Password reset successful",
    };
  }
}