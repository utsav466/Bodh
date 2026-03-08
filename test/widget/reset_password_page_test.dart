import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bodh_flutter/features/auth/presentation/pages/reset_password_page.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_view_model.dart';

void main() {
  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => FakeAuthViewModel()),
      ],
      child: const MaterialApp(
        home: ResetPasswordPage(),
      ),
    );
  }

  testWidgets('ResetPasswordPage shows all required fields', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsWidgets);
    expect(find.widgetWithText(TextFormField, '6-Digit Reset Code'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'New Password'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
  });

  testWidgets('ResetPasswordPage navigates to LoginPage after valid submit', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, '6-Digit Reset Code'),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'New Password'),
      'password123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      'password123',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}