// import 'package:bodh_flutter/core/services/hive/hive_service.dart';
// import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
// import 'package:bodh_flutter/features/auth/data/datasources/auth_datasource.dart';
// import 'package:bodh_flutter/features/auth/data/models/auth_hive_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// //provider
// final authLocalDataSourceProvider= Provider<AuthLocalDatasource>((ref){
//   final hiveService =ref.read(hiveServiceProvider);
//   final userSessionService = ref.read(userSessionServiceProvider);
//   return AuthLocalDatasource(
//     hiveService: hiveService,
//     userSessionService: userSessionService,
//     );
  
// });

// class AuthLocalDatasource implements IAuthDatasource{
  
//   final HiveService _hiveService;
//   final UserSessionService _userSessionService;

//   AuthLocalDatasource({
//     required HiveService hiveService, 
//     required UserSessionService userSessionService})
//   : _hiveService = hiveService,
//   _userSessionService= userSessionService;

//   @override
//   Future<AuthHiveModel?> getCurrentUser() {
//     // TODO: implement getCurrentUser
//     throw UnimplementedError();
//   }

//   @override
//   Future<bool> isEmailExists(String email) {
//     try {
//       final exists =_hiveService.isEmailExists(email);
//       return Future.value(exists);
//     } catch (e) {
//       return Future.value(false);
//     }
//   }

//   @override
//   Future<AuthHiveModel?> login(String email, String password) async{
//     try {

//       final user = await _hiveService.loginUser(email, password);
//       if(user != null){
//         await _userSessionService.saveUserSession(
//           userId: user.authId!,
//           email: user.email,
//           username: user.username,
//           fullName: user.fullName,
//           phoneNumber: user.phoneNumber,
//           batchId: user.batchId,
//           profilePicture: user.profilePicture
//           );
//       }
//       return user;
//     } catch (e) {

//       return Future.value(null);
//     }
//   }

//   @override
//   Future<bool> logout() async{
//     try {
//       await _hiveService.logoutUser();
//       return Future.value(true);
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Future<bool> register(AuthHiveModel model) async{
   
//     try {
//      await _hiveService.registerUser(model);
//       return Future.value(true);
//     } catch (e) {
//       return Future.value(false);
//     }

//   }

// }


import 'package:bodh_flutter/core/services/hive/hive_service.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodh_flutter/features/auth/data/datasources/auth_datasource.dart';

// import 'package:lost_n_found/core/services/hive/hive_service.dart';
// import 'package:lost_n_found/core/services/storage/user_session_service.dart';
// import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
// import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';

final authLocalDatasourceProvider = Provider<IAuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          username: user.username,
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          // batchId: user.batchId,
          profilePicture: user.profilePicture ?? '',
        );
      }

      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthHiveModel> register(AuthHiveModel model) async {
    return await _hiveService.registerUser(model);
  }

  @override
  Future<bool> deleteUser(String authId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
