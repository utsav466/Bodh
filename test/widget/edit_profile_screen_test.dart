import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/dashboard/presentation/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late UserSessionService userSessionService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'is_logged_in': true,
      'user_id': '123',
      'user_email': 'test@mail.com',
      'username': 'testuser',
      'user_full_name': 'Test User',
    });

    prefs = await SharedPreferences.getInstance();
    userSessionService = UserSessionService(prefs: prefs);
  });

  testWidgets('EditProfileScreen save button is tappable', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          userSessionServiceProvider.overrideWithValue(userSessionService),
        ],
        child: const MaterialApp(
          home: EditProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // ✅ EXACT TEXT USED IN UI
    final saveButton = find.widgetWithText(ElevatedButton, 'Save Changes');

    expect(saveButton, findsOneWidget);

    await tester.tap(saveButton);
    await tester.pump();

    // No crash = tappable
    expect(true, isTrue);
  });
}
