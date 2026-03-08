import 'dart:io';

import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IAuthRepository {

  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, bool>> forgotPassword(String email);
Future<Either<Failure, bool>> resetPassword(String token, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();


  // ✅ ONLY NEW METHOD
  Future<Either<Failure, AuthEntity>> updateAvatar(File image);
}
