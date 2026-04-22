import 'package:flutter_test/flutter_test.dart';
import 'package:tapparty/data/hidden_tasks.dart';
import 'package:tapparty/l10n/app_locale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('who pays scenarios are available in Russian', () {
    AppLocale.notifier.value = 'ru';

    final List<String> scenarios = hiddenTasksForMode('who_pays');

    expect(scenarios, isNotEmpty);
    expect(scenarios.first, contains('П'));
  });

  test('who pays scenarios are available in English', () {
    AppLocale.notifier.value = 'en';

    final List<String> scenarios = hiddenTasksForMode('who_pays');

    expect(scenarios, isNotEmpty);
    expect(scenarios.first, contains('Pays'));
  });
}
