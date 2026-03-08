import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late ForgotPasswordUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = ForgotPasswordUsecase(authRepository: mockRepository);
  });

  const params = ForgotPasswordUsecaseParams(
    email: 'utsav@gmail.com',
  );

  test('should return true when forgot password is successful', () async {
    when(() => mockRepository.forgotPassword(params.email))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(params);

    expect(result, const Right(true));
    verify(() => mockRepository.forgotPassword(params.email)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when forgot password fails', () async {
    const failure = ApiFailure(
      message: 'No account found with this email',
      statusCode: 404,
    );

    when(() => mockRepository.forgotPassword(params.email))
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(params);

    expect(result, const Left(failure));
    verify(() => mockRepository.forgotPassword(params.email)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}