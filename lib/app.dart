import 'package:flutter/material.dart';
import 'package:tapparty/l10n/app_locale.dart';
import 'package:tapparty/screens/home_screen.dart';
import 'package:tapparty/theme/app_theme.dart';

class TapPartyApp extends StatelessWidget {
  const TapPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.notifier,
      builder: (BuildContext context, String locale, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'tap.',
          theme: AppTheme.darkTheme(),
          home: const HomeScreen(),
        );
      },
    );
  }
}
