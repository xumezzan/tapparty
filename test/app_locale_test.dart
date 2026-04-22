import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapparty/l10n/app_locale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('initialize restores saved locale', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app_locale': 'en',
    });

    await AppLocale.initialize();

    expect(AppLocale.notifier.value, 'en');
  });

  test('set persists locale changes', () async {
    await AppLocale.initialize();

    AppLocale.set('en');
    await AppLocale.persist('en');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_locale'), 'en');
  });
}
