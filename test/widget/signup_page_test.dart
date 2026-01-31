import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bodh_flutter/features/auth/presentation/pages/signup_page.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';

import '../helpers/fake_auth_view_model.dart';

void main() {
  testWidgets(
    'SignupPage shows required input fields and signup button',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(
              () => FakeAuthViewModel(),
            ),
          ],
          child: const MaterialApp(
            home: SignUpScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Headings
      expect(find.text('Create an account'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Fields
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Phone'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        findsOneWidget,
      );

      // Button
      expect(find.text('Signup'), findsOneWidget);
    },
  );
}
