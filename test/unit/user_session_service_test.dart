import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';

void main() {
  group('UserSessionService', () {
    test('saveUserSession prefers avatarUrl over profilePicture', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = UserSessionService(prefs: prefs);

      await service.saveUserSession(
        userId: '1',
        email: 'a@a.com',
        username: 'aaa',
        fullName: 'AAA',
        profilePicture: '/uploads/old.png',
        avatarUrl: '/uploads/new.png',
      );

      expect(service.isLoggedIn(), true);
      expect(service.getUserId(), '1');
      expect(service.getAvatarUrl(), '/uploads/new.png');
      expect(service.getUserProfileImage(), '/uploads/new.png');
    });

    test('clearUserSession removes stored session values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = UserSessionService(prefs: prefs);

      await service.saveUserSession(
        userId: '1',
        email: 'a@a.com',
        username: 'aaa',
        fullName: 'AAA',
        phoneNumber: '999',
        avatarUrl: '/uploads/new.png',
      );

      await service.clearUserSession();

      expect(service.isLoggedIn(), false);
      expect(service.getUserId(), isNull);
      expect(service.getEmail(), isNull);
      expect(service.getUsername(), isNull);
      expect(service.getFullName(), isNull);
      expect(service.getPhoneNumber(), isNull);
      expect(service.getAvatarUrl(), isNull);
    });
  });
}
