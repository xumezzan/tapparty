import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocale {
  AppLocale._();

  static const String _fallbackLocale = 'ru';
  static const String _localeKey = 'app_locale';
  static const Set<String> _supportedLocales = <String>{'ru', 'en'};

  static final ValueNotifier<String> notifier = ValueNotifier<String>(
    _fallbackLocale,
  );
  static SharedPreferences? _prefs;

  static bool get isEn => notifier.value == 'en';

  static Future<void> initialize() async {
    notifier.value = _fallbackLocale;
    _prefs = await SharedPreferences.getInstance();
    final String? savedLocale = _prefs!.getString(_localeKey);
    if (savedLocale != null && _supportedLocales.contains(savedLocale)) {
      notifier.value = savedLocale;
    }
  }

  static Future<void> persist(String locale) async {
    final SharedPreferences prefs =
        _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale);
  }

  static void set(String locale) {
    if (!_supportedLocales.contains(locale) || notifier.value == locale) {
      return;
    }

    notifier.value = locale;
    unawaited(persist(locale));
  }
}
