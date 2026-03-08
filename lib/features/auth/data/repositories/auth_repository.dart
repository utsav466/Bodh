import 'dart:io';

import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/core/services/connectivity/network_info.dart';
import 'package:bodh_flutter/features/auth/data/datasources/auth_datasource.dart';
import 'package:bodh_flutter/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:bodh_flutter/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_api_model.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_hive_model.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:bodh_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return AuthRepository(
    authDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required NetworkInfo networkInfo,
  })  : _authLocalDatasource = authDatasource,
        _authRemoteDatasource = authRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authLocalDatasource.getCurrentUser();
      if (model != null) {
        return Right(model.toEntity());
      }
      return Left(
        LocalDatabaseFailure(message: "Failed to get current user"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDatasource.login(email, password);
        if (result != null) {
          return Right(result.toEntity());
        }
        return Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Login Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _authLocalDatasource.login(email, password);
        if (model != null) {
          return Right(model.toEntity());
        }
        return Left(LocalDatabaseFailure(message: "User not found"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authLocalDatasource.logout();
      if (result) return const Right(true);
      return Left(LocalDatabaseFailure(message: "Failed to Logout user"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDatasource.register(userModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Registration failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final existingUser =
            await _authLocalDatasource.getUserByEmail(entity.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final model = AuthHiveModel.fromEntity(entity);
        await _authLocalDatasource.register(model);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateAvatar(File image) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: "No internet connection"));
    }

    try {
      final result = await _authRemoteDatasource.updateAvatar(image);

      if (result != null) {
        final entity = result.toEntity();

        await _authLocalDatasource.updateUser(
          AuthHiveModel.fromEntity(entity),
        );

        return Right(entity);
      }

      return const Left(ApiFailure(message: "Avatar update failed"));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: e.response?.data["message"] ?? "Avatar upload failed",
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: "No internet connection"));
    }

    try {
      final result = await _authRemoteDatasource.forgotPassword(email);

      if (result != null && result["success"] == true) {
        return const Right(true);
      }

      return Left(
        ApiFailure(
          message: result?["message"]?.toString() ?? "Forgot password failed",
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: e.response?.data["message"] ?? "Forgot password failed",
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String token,
    String password,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: "No internet connection"));
    }

    try {
      final result = await _authRemoteDatasource.resetPassword(
        token,
        password,
      );

      if (result != null && result["success"] == true) {
        return const Right(true);
      }

      return Left(
        ApiFailure(
          message: result?["message"]?.toString() ?? "Reset password failed",
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: e.response?.data["message"] ?? "Reset password failed",
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}