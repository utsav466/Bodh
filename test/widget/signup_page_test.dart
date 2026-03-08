import 'package:bodh_flutter/features/auth/presentation/pages/signup_page.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_view_model.dart';

void main() {
  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(
          () => FakeAuthViewModel(),
        ),
      ],
      child: const MaterialApp(
        home: SignUpScreen(),
      ),
    );
  }

  testWidgets(
    'SignupPage shows required input fields and signup button',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create an account'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.text('Signup'), findsOneWidget);
    },
  );

  testWidgets('SignupPage validates empty fields', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final signupButton = find.text('Signup');
    await tester.ensureVisible(signupButton);
    await tester.tap(signupButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsNWidgets(4));
  });

  testWidgets('SignupPage validates confirm password mismatch', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'Utsav');
    await tester.enterText(fields.at(1), '9800000000');
    await tester.enterText(fields.at(2), 'utsav@mail.com');
    await tester.enterText(fields.at(3), 'password123');
    await tester.enterText(fields.at(4), 'wrong123');

    final signupButton = find.text('Signup');
    await tester.ensureVisible(signupButton);
    await tester.tap(signupButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('SignupPage navigates to Login page', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final loginText = find.text(' Login');
    await tester.ensureVisible(loginText);
    await tester.tap(loginText, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Check destination screen text instead of byType(LoginPage)
    expect(find.text('Login to your account'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });
}