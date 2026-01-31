import 'package:flutter_test/flutter_test.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_hive_model.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';

void main() {
  test('AuthHiveModel converts to AuthEntity correctly', () {
    final hiveModel = AuthHiveModel(
      authId: '1',
      fullName: 'Utsav',
      email: 'u@gmail.com',
      username: 'utsav',
      profilePicture: '/uploads/a.png',
    );

    final entity = hiveModel.toEntity();

    expect(entity.fullName, 'Utsav');
    expect(entity.profilePicture, '/uploads/a.png');
  });

  test('AuthHiveModel.fromEntity works correctly', () {
    const entity = AuthEntity(
      authId: '2',
      fullName: 'Test',
      email: 't@test.com',
      username: 'test',
      profilePicture: '/img.png',
    );

    final model = AuthHiveModel.fromEntity(entity);

    expect(model.email, 't@test.com');
    expect(model.profilePicture, '/img.png');
  });
}
