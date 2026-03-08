import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/core/usecases/app_usecase.dart';
import 'package:bodh_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordUsecaseParams extends Equatable {
  final String email;

  const ForgotPasswordUsecaseParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ForgotPasswordUsecase(authRepository: authRepository);
});

class ForgotPasswordUsecase
    implements UsecaseWithParams<bool, ForgotPasswordUsecaseParams> {
  final IAuthRepository _authRepository;

  ForgotPasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(ForgotPasswordUsecaseParams params) {
    return _authRepository.forgotPassword(params.email);
  }
}