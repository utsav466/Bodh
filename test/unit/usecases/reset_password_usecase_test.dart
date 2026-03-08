import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late ResetPasswordUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = ResetPasswordUsecase(authRepository: mockRepository);
  });

  const params = ResetPasswordUsecaseParams(
    token: '123456',
    password: 'newpassword123',
  );

  test('should return true when reset password is successful', () async {
    when(() => mockRepository.resetPassword(params.token, params.password))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(params);

    expect(result, const Right(true));
    verify(() => mockRepository.resetPassword(params.token, params.password))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when reset password fails', () async {
    const failure = ApiFailure(
      message: 'Invalid or expired reset code',
      statusCode: 400,
    );

    when(() => mockRepository.resetPassword(params.token, params.password))
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(params);

    expect(result, const Left(failure));
    verify(() => mockRepository.resetPassword(params.token, params.password))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}