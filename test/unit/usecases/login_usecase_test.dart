import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const params = LoginUsecaseParams(
    email: 'test@gmail.com',
    password: '123456',
  );

  const authEntity = AuthEntity(
    authId: '1',
    fullName: 'Utsav Thapa',
    email: 'test@gmail.com',
    username: 'utsav',
    password: '123456',
    phoneNumber: '9800000000',
    batchId: null,
    batch: null,
    profilePicture: null,
  );

  test('should return AuthEntity when login is successful', () async {
    when(() => mockRepository.login(params.email, params.password))
        .thenAnswer((_) async => const Right(authEntity));

    final result = await usecase(params);

    expect(result, const Right(authEntity));
    verify(() => mockRepository.login(params.email, params.password)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when login fails', () async {
    const failure = ApiFailure(
      message: 'Invalid credentials',
      statusCode: 401,
    );

    when(() => mockRepository.login(params.email, params.password))
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(params);

    expect(result, const Left(failure));
    verify(() => mockRepository.login(params.email, params.password)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}