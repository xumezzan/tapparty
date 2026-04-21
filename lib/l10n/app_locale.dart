import 'package:flutter/foundation.dart';

class AppLocale {
  AppLocale._();

  static final ValueNotifier<String> notifier = ValueNotifier<String>('ru');

  static bool get isEn => notifier.value == 'en';

  static void set(String locale) => notifier.value = locale;
}
