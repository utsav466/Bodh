import 'dart:io';

import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateAvatarUsecaseProvider = Provider<UpdateAvatarUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UpdateAvatarUsecase(repository);
});

class UpdateAvatarUsecase {
  final IAuthRepository _repository;

  UpdateAvatarUsecase(this._repository);

  Future<Either<Failure, AuthEntity>> call(File image) {
    return _repository.updateAvatar(image);
  }
}
