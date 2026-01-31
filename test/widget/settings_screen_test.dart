import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bodh_flutter/features/dashboard/presentation/settings_screen.dart';

void main() {
  testWidgets(
    'SettingsScreen renders correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // AppBar title (adjust text if your title is different)
      expect(find.byType(AppBar), findsOneWidget);

      // Screen body exists
      expect(find.byType(Scaffold), findsOneWidget);

      // At least one settings option exists
      expect(find.byType(ListTile), findsWidgets);
    },
  );
}
