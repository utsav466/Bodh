import 'package:bodh_flutter/features/dashboard/presentation/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bodh_flutter/features/dashboard/presentation/settings_screen.dart';

void main() {
  Widget buildTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: SettingsScreen(),
      ),
    );
  }

  testWidgets('SettingsScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('SettingsScreen shows section titles', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('SettingsScreen toggles Notifications switch', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final switchesBefore = tester.widgetList<SwitchListTile>(
      find.byType(SwitchListTile),
    ).toList();

    expect(switchesBefore[0].value, true);

    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    final switchesAfter = tester.widgetList<SwitchListTile>(
      find.byType(SwitchListTile),
    ).toList();

    expect(switchesAfter[0].value, false);
  });

  testWidgets('SettingsScreen navigates to ChangePasswordScreen', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change Password'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangePasswordScreen), findsOneWidget);
  });
}