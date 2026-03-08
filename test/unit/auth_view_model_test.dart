import 'dart:io';

import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/update_avatar_usecase.dart';
import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockUpdateAvatarUsecase extends Mock implements UpdateAvatarUsecase {}

class MockAuthRemoteRepository extends Mock implements AuthRemoteRepository {}

class FakeRegisterParams extends Fake implements RegisterUsecaseParams {}

class FakeLoginParams extends Fake implements LoginUsecaseParams {}

void main() {
  late ProviderContainer container;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockUpdateAvatarUsecase mockUpdateAvatarUsecase;
  late MockAuthRemoteRepository mockAuthRemoteRepository;

  const authEntity = AuthEntity(
    authId: '1',
    fullName: 'Utsav Thapa',
    email: 'utsav@gmail.com',
    username: 'utsav',
    password: '123456',
    phoneNumber: '9800000000',
    batchId: null,
    batch: null,
    profilePicture: null,
  );

  setUpAll(() {
    registerFallbackValue(FakeRegisterParams());
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockUpdateAvatarUsecase = MockUpdateAvatarUsecase();
    mockAuthRemoteRepository = MockAuthRemoteRepository();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        updateAvatarUsecaseProvider.overrideWithValue(mockUpdateAvatarUsecase),
        authRemoteRepositoryProvider.overrideWithValue(mockAuthRemoteRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('AuthViewModel initial state is initial', () {
    final state = container.read(authViewModelProvider);

    expect(state.status, AuthStatus.initial);
    expect(state.authEntity, isNull);
    expect(state.errorMessage, isNull);
    expect(state.successMessage, isNull);
  });

  test('register sets loading state first', () {
    when(() => mockRegisterUsecase(any())).thenAnswer(
      (_) async => const Right(true),
    );

    final notifier = container.read(authViewModelProvider.notifier);

    notifier.register(
      fullName: 'Utsav Thapa',
      email: 'utsav@gmail.com',
      phoneNumber: '9800000000',
      username: 'utsav',
      password: '123456',
    );

    final loadingState = container.read(authViewModelProvider);
    expect(loadingState.status, AuthStatus.loading);
  });

  test('register success sets registered state and success message', () async {
    when(() => mockRegisterUsecase(any())).thenAnswer(
      (_) async => const Right(true),
    );

    final notifier = container.read(authViewModelProvider.notifier);

    await notifier.register(
      fullName: 'Utsav Thapa',
      email: 'utsav@gmail.com',
      phoneNumber: '9800000000',
      username: 'utsav',
      password: '123456',
    );

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.registered);
    expect(state.successMessage, 'User registered successfully');
    expect(state.errorMessage, isNull);
  });

  test('register failure sets error state and error message', () async {
    const failure = ApiFailure(
      message: 'Registration failed',
      statusCode: 400,
    );

    when(() => mockRegisterUsecase(any())).thenAnswer(
      (_) async => const Left(failure),
    );

    final notifier = container.read(authViewModelProvider.notifier);

    await notifier.register(
      fullName: 'Utsav Thapa',
      email: 'utsav@gmail.com',
      phoneNumber: '9800000000',
      username: 'utsav',
      password: '123456',
    );

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.error);
    expect(state.errorMessage, 'Registration failed');
  });

  test('login sets loading state first', () {
    when(() => mockLoginUsecase(any())).thenAnswer(
      (_) async => const Right(authEntity),
    );

    final notifier = container.read(authViewModelProvider.notifier);

    notifier.login(
      email: 'utsav@gmail.com',
      password: '123456',
    );

    final loadingState = container.read(authViewModelProvider);
    expect(loadingState.status, AuthStatus.loading);
  });

  test('login success sets authenticated state and auth entity', () async {
    when(() => mockLoginUsecase(any())).thenAnswer(
      (_) async => const Right(authEntity),
    );

    final notifier = container.read(authViewModelProvider.notifier);

    await notifier.login(
      email: 'utsav@gmail.com',
      password: '123456',
    );

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.authEntity, authEntity);
    expect(state.successMessage, 'Login successful');
    expect(state.errorMessage, isNull);
  });

  test('login failure sets error state and error message', () async {
    const failure = ApiFailure(
      message: 'Invalid credentials',
      statusCode: 401,
    );

    when(() => mockLoginUsecase(any())).thenAnswer(
      (_) async => const Left(failure),
    );

    final notifier = container.read(authViewModelProvider.notifier);

    await notifier.login(
      email: 'utsav@gmail.com',
      password: 'wrongpassword',
    );

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.error);
    expect(state.errorMessage, 'Invalid credentials');
  });

  test('updateAvatar sets loading state first', () async {
    final notifier = container.read(authViewModelProvider.notifier);
    final fakeImage = File('test/resources/fake_image.png');

    when(() => mockUpdateAvatarUsecase(fakeImage)).thenAnswer(
      (_) async => const Right(authEntity),
    );

    final future = notifier.updateAvatar(fakeImage);

    final loadingState = container.read(authViewModelProvider);
    expect(loadingState.status, AuthStatus.loading);

    await future;
  });

  test('updateAvatar success sets authenticated state', () async {
    final notifier = container.read(authViewModelProvider.notifier);
    final fakeImage = File('test/resources/fake_image.png');

    when(() => mockUpdateAvatarUsecase(fakeImage)).thenAnswer(
      (_) async => const Right(authEntity),
    );

    await notifier.updateAvatar(fakeImage);

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.authEntity, authEntity);
    expect(state.successMessage, 'Profile picture updated successfully');
    expect(state.errorMessage, isNull);
  });

  test('updateAvatar failure sets error state and error message', () async {
    final notifier = container.read(authViewModelProvider.notifier);
    final fakeImage = File('test/resources/fake_image.png');

    const failure = ApiFailure(
      message: 'Avatar upload failed',
      statusCode: 500,
    );

    when(() => mockUpdateAvatarUsecase(fakeImage)).thenAnswer(
      (_) async => const Left(failure),
    );

    await notifier.updateAvatar(fakeImage);

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.error);
    expect(state.errorMessage, 'Avatar upload failed');
    expect(state.successMessage, isNull);
  });
}