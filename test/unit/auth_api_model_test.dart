import 'package:flutter_test/flutter_test.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_api_model.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthApiModel', () {
    test('toJson uses avatarUrl key (not profilePicture)', () {
      final model = AuthApiModel(
        authId: '1',
        fullName: 'Utsav',
        email: 'u@u.com',
        username: 'utsav',
        profilePicture: '/uploads/a.png',
      );

      final json = model.toJson();

      expect(json.containsKey('avatarUrl'), true);
      expect(json['avatarUrl'], '/uploads/a.png');
      expect(json.containsKey('profilePicture'), false);
    });

    test('toJson sets confirmPassword = password when confirmPassword is null', () {
      final model = AuthApiModel(
        fullName: 'Utsav',
        email: 'u@u.com',
        username: 'utsav',
        password: '123456',
        confirmPassword: null,
      );

      final json = model.toJson();

      expect(json['password'], '123456');
      expect(json['confirmPassword'], '123456');
    });

    test('fromJson reads avatarUrl into profilePicture', () {
      final model = AuthApiModel.fromJson({
        '_id': 'abc',
        'fullName': 'Utsav',
        'email': 'u@u.com',
        'username': 'utsav',
        'avatarUrl': '/uploads/new.png',
      });

      expect(model.authId, 'abc');
      expect(model.profilePicture, '/uploads/new.png');
    });

    test('fromEntity + toEntity preserves profilePicture', () {
      const entity = AuthEntity(
        authId: 'x',
        fullName: 'Test',
        email: 't@t.com',
        username: 'test',
        profilePicture: '/uploads/p.png',
      );

      final model = AuthApiModel.fromEntity(entity);
      final backToEntity = model.toEntity();

      expect(backToEntity.profilePicture, '/uploads/p.png');
      expect(backToEntity.fullName, 'Test');
      expect(backToEntity.email, 't@t.com');
      expect(backToEntity.username, 'test');
    });
  });
}
