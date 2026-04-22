import 'package:flutter_test/flutter_test.dart';
import 'package:tapparty/data/hidden_tasks.dart';
import 'package:tapparty/l10n/app_locale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AppLocale.notifier.value = 'ru';
  });

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

  test('pickHiddenTaskIndex does not repeat until queue is exhausted', () {
    final List<String> tasks = hiddenTasksForMode('truth');
    final Set<int> picked = <int>{};

    for (int i = 0; i < tasks.length; i++) {
      final int index = pickHiddenTaskIndex('truth', tasks.length);
      expect(index, inInclusiveRange(0, tasks.length - 1));
      expect(picked.add(index), isTrue);
    }
  });
}
