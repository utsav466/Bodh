import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String fullName;
  final String email;
  final String username;
  final String? password;
  final String? confirmPassword;   // ✅ added for backend validation
  final String? phoneNumber;
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

  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,                  // ✅ backend expects fullName
      "email": email,
      "username": username,
      "phoneNumber": phoneNumber,
      "password": password,
      "confirmPassword": confirmPassword ?? password, // ✅ send confirmPassword
      "profilePicture": profilePicture,
    };
  }

  /// Create model from API JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json["_id"] as String?,
      fullName: json["fullName"] as String? ?? json["name"] as String,
      email: json["email"] as String,
      username: json["username"] as String,
      phoneNumber: json["phoneNumber"] as String?,
      profilePicture: json["profilePicture"] as String?,
    );
  }

  /// Convert to domain entity
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

  /// Create model from domain entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.password, // ✅ send same password for confirmation
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }

  /// Convert list of models to list of entities
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
