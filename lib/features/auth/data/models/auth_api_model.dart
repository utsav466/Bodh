import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String fullName;
  final String email;
  final String username;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;

  // ✅ keep old name used in app
  final String? profilePicture;

  AuthApiModel({
    this.authId,
    required this.fullName,
    required this.email,
    required this.username,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "username": username,
      "phoneNumber": phoneNumber,
      "password": password,
      "confirmPassword": confirmPassword ?? password,

      // ✅ backend expects avatarUrl, not profilePicture
      "avatarUrl": profilePicture,
    };
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json["_id"]?.toString(),
      fullName: (json["fullName"] ?? json["name"] ?? "") as String,
      email: (json["email"] ?? "") as String,
      username: (json["username"] ?? "") as String,
      phoneNumber: json["phoneNumber"]?.toString(),

      // ✅ backend returns avatarUrl
      profilePicture: json["avatarUrl"]?.toString() ??
          json["profilePicture"]?.toString(),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      password: password,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      confirmPassword: entity.password,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }

  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
