import 'dart:io';

import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    // ✅ REQUIRED: mock SharedPreferences for tests
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // =========================
  // TEST 1: INITIAL STATE
  // =========================
  test('AuthViewModel initial state is initial', () {
    final state = container.read(authViewModelProvider);

    expect(state.status, AuthStatus.initial);
    expect(state.authEntity, isNull);
    expect(state.errorMessage, isNull);
    expect(state.successMessage, isNull);
  });

  // =========================
  // TEST 2: updateAvatar sets loading state
  // =========================
  test('updateAvatar sets loading state first', () async {
    final notifier =
        container.read(authViewModelProvider.notifier);

    final fakeImage = File('test/resources/fake_image.png');

    // fire & don't await immediately
    final future = notifier.updateAvatar(fakeImage);

    final loadingState = container.read(authViewModelProvider);
    expect(loadingState.status, AuthStatus.loading);

    await future;
  });
}
