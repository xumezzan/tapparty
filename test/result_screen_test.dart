import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapparty/l10n/app_locale.dart';
import 'package:tapparty/l10n/strings.dart';
import 'package:tapparty/screens/result_screen.dart';
import 'package:tapparty/theme/app_theme.dart';
import 'package:tapparty/models/game_mode.dart';

void main() {
  testWidgets('who pays result shows pay scenario card', (
    WidgetTester tester,
  ) async {
    AppLocale.set('en');

    const GameMode mode = GameMode(
      id: 'who_pays',
      title: 'Кто платит',
      titleEn: 'Who Pays',
      subtitle: 'Случайный игрок платит за всю компанию.',
      subtitleEn: 'A random player pays for the group.',
      accentColor: AppTheme.pink,
      icon: Icons.payments_rounded,
      examples: <String>['Кто-то платит за кофе.'],
      examplesEn: <String>['Someone pays for coffee.'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ResultScreen(
          mode: mode,
          taskText: 'Pays for coffee for everyone.',
          customTaskText: null,
          selectedPlayerLabel: S.player(2),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(S.payScenario), findsOneWidget);
    expect(find.text('Pays for coffee for everyone.'), findsOneWidget);
  });
}
