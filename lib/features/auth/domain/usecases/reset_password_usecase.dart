import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/core/usecases/app_usecase.dart';
import 'package:bodh_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordUsecaseParams extends Equatable {
  final String token;
  final String password;

  const ResetPasswordUsecaseParams({
    required this.token,
    required this.password,
  });

  @override
  List<Object?> get props => [token, password];
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ResetPasswordUsecase(authRepository: authRepository);
});

class ResetPasswordUsecase
    implements UsecaseWithParams<bool, ResetPasswordUsecaseParams> {
  final IAuthRepository _authRepository;

  ResetPasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(ResetPasswordUsecaseParams params) {
    return _authRepository.resetPassword(
      params.token,
      params.password,
    );
  }
}