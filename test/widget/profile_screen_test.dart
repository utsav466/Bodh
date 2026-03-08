import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bodh_flutter/features/dashboard/presentation/bottom%20screen/profile.dart';
import 'package:bodh_flutter/features/dashboard/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SharedPreferences> getPrefs() async {
    SharedPreferences.setMockInitialValues({
      'is_logged_in': true,
      'user_id': '1',
      'user_email': 'test@mail.com',
      'username': 'testuser',
      'user_full_name': 'Test User',
    });

    return await SharedPreferences.getInstance();
  }

  Future<Widget> buildTestWidget() async {
    final prefs = await getPrefs();

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  testWidgets('ProfileScreen shows name and email', (tester) async {
    await tester.pumpWidget(await buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@mail.com'), findsOneWidget);
  });

  testWidgets('ProfileScreen shows action tiles', (tester) async {
    await tester.pumpWidget(await buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('ProfileScreen navigates to EditProfileScreen', (tester) async {
    await tester.pumpWidget(await buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsWidgets);
  });

  testWidgets('ProfileScreen navigates to SettingsScreen', (tester) async {
    await tester.pumpWidget(await buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('ProfileScreen logout navigates to LoginPage', (tester) async {
    await tester.pumpWidget(await buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}