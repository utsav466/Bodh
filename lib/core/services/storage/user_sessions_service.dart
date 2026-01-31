import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized in main.dart',
  );
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyEmail = 'user_email';
  static const String _keyUsername = 'username';
  static const String _keyFullName = 'user_full_name';
  static const String _keyPhoneNumber = 'user_phone_number';

  // ✅ store image url/path here
  static const String _keyUserProfileImage = 'user_profile_image';

  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String username,
    required String fullName,
    String? phoneNumber,

    // ✅ support both names
    String? profilePicture,
    String? avatarUrl,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyUsername, username);
    await _prefs.setString(_keyFullName, fullName);

    if (phoneNumber != null) {
      await _prefs.setString(_keyPhoneNumber, phoneNumber);
    }

    // ✅ prefer avatarUrl if provided, otherwise profilePicture
    final imageValue = avatarUrl ?? profilePicture;
    if (imageValue != null && imageValue.isNotEmpty) {
      await _prefs.setString(_keyUserProfileImage, imageValue);
    }
  }

  Future<void> clearUserSession() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyFullName);
    await _prefs.remove(_keyPhoneNumber);
    await _prefs.remove(_keyUserProfileImage);
    await _prefs.remove(_keyIsLoggedIn);
  }

  bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

  String? getUserId() => _prefs.getString(_keyUserId);
  String? getEmail() => _prefs.getString(_keyEmail);
  String? getUsername() => _prefs.getString(_keyUsername);
  String? getFullName() => _prefs.getString(_keyFullName);
  String? getPhoneNumber() => _prefs.getString(_keyPhoneNumber);

  // ✅ old getter name (used by existing code)
  String? getUserProfileImage() => _prefs.getString(_keyUserProfileImage);

  // ✅ new getter name (used by new code)
  String? getAvatarUrl() => _prefs.getString(_keyUserProfileImage);

  Future<UserSession?> getUserSession() async {
    final userId = getUserId();
    if (userId == null || userId.isEmpty) return null;

    return UserSession(
      userId: userId,
      email: getEmail() ?? '',
      username: getUsername() ?? '',
      fullName: getFullName() ?? '',
      phoneNumber: getPhoneNumber(),
      avatarUrl: getAvatarUrl(),
      profilePicture: getUserProfileImage(),
    );
  }
}

class UserSession {
  final String userId;
  final String email;
  final String username;
  final String fullName;
  final String? phoneNumber;

  // ✅ expose both
  final String? avatarUrl;
  final String? profilePicture;

  const UserSession({
    required this.userId,
    required this.email,
    required this.username,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.profilePicture,
  });
}
