import 'package:flutter_test/flutter_test.dart';
import 'package:bodh_flutter/features/auth/domain/entities/auth_entity.dart';

void main() {
  test('AuthEntity supports value equality', () {
    const user1 = AuthEntity(
      authId: '1',
      fullName: 'Utsav Thapa',
      email: 'utsav@gmail.com',
      username: 'utsav',
    );

    const user2 = AuthEntity(
      authId: '1',
      fullName: 'Utsav Thapa',
      email: 'utsav@gmail.com',
      username: 'utsav',
    );

    expect(user1, equals(user2));
  });
}
