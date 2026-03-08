import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  const params = RegisterUsecaseParams(
    fullName: 'Utsav Thapa',
    email: 'utsav@gmail.com',
    phoneNumber: '9800000000',
    batchId: null,
    username: 'utsav',
    password: '123456',
  );

  const expectedEntity = AuthEntity(
    fullName: 'Utsav Thapa',
    email: 'utsav@gmail.com',
    phoneNumber: '9800000000',
    batchId: null,
    username: 'utsav',
    password: '123456',
    batch: null,
    profilePicture: null,
  );

  test('should return true when register is successful', () async {
    when(() => mockRepository.register(expectedEntity))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(params);

    expect(result, const Right(true));
    verify(() => mockRepository.register(expectedEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when register fails', () async {
    const failure = ApiFailure(
      message: 'Registration failed',
      statusCode: 400,
    );

    when(() => mockRepository.register(expectedEntity))
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(params);

    expect(result, const Left(failure));
    verify(() => mockRepository.register(expectedEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}