import 'package:bodh_flutter/features/dashboard/presentation/bottom%20screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bodh_flutter/features/dashboard/presentation/profile_screen.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';

void main() {
  testWidgets('ProfileScreen shows name and email', (tester) async {
    SharedPreferences.setMockInitialValues({
      'is_logged_in': true,
      'user_id': '1',
      'user_email': 'test@mail.com',
      'username': 'testuser',
      'user_full_name': 'Test User',
    });

    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@mail.com'), findsOneWidget);
  });
  testWidgets('ProfileScreen navigates to EditProfileScreen', (tester) async {
  SharedPreferences.setMockInitialValues({
    'is_logged_in': true,
    'user_id': '1',
    'user_email': 'test@mail.com',
    'username': 'testuser',
    'user_full_name': 'Test User',
  });

  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    ),
  );

  await tester.pumpAndSettle();

  await tester.tap(find.text('Edit Profile'));
  await tester.pumpAndSettle();

  expect(find.text('Edit Profile'), findsWidgets);
});
}
