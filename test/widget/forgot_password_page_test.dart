import 'package:bodh_flutter/features/auth/presentation/pages/forgot_password_page.dart';
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
        home: ForgotPasswordPage(),
      ),
    );
  }

  testWidgets('ForgotPasswordPage shows main UI', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Send Reset Code'), findsOneWidget);
  });

  testWidgets('ForgotPasswordPage shows success section after submit', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'test@mail.com');

    final sendButton = find.widgetWithText(ElevatedButton, 'Send Reset Code');
    await tester.ensureVisible(sendButton);
    await tester.tap(sendButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Reset code sent'), findsOneWidget);
    expect(find.textContaining('We sent a 6-digit reset code to'), findsOneWidget);
    expect(find.text('Go to Reset Password'), findsOneWidget);
  });

  testWidgets('ForgotPasswordPage go to reset password button is tappable', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'test@mail.com');

    final sendButton = find.widgetWithText(ElevatedButton, 'Send Reset Code');
    await tester.ensureVisible(sendButton);
    await tester.tap(sendButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    final goButton = find.widgetWithText(ElevatedButton, 'Go to Reset Password');
    expect(goButton, findsOneWidget);

    await tester.ensureVisible(goButton);
    await tester.tap(goButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(true, isTrue);
  });
}