import 'app_locale.dart';

abstract final class S {
  // Home
  static String get homeDescription => AppLocale.isEn
      ? 'Quick game for your crew. Place fingers on the screen, wait for the neon pick, and find out who gets the task.'
      : 'Быстрая игра для компании. Положите пальцы на экран, дождитесь неонового выбора и узнайте, кто выполняет задание.';
  static String get start => AppLocale.isEn ? 'Start' : 'Старт';

  // Mode selection
  static String get chooseMode =>
      AppLocale.isEn ? 'Choose a mode' : 'Выбери режим';
  static String get chooseModeHint => AppLocale.isEn
      ? 'The first three modes pull a hidden challenge automatically. Manual input is only in Custom task.'
      : 'Первые три режима сами вытягивают скрытый челлендж. Ручной ввод остаётся только в Custom task.';


  // Touch screen
  static String get placeFingersPrompt =>
      AppLocale.isEn ? 'Place 2–5 fingers' : 'Положите 2–5 пальцев';
  static String get needOneMore =>
      AppLocale.isEn ? 'Need one more player' : 'Нужен ещё один игрок';
  static String get keepFingers =>
      AppLocale.isEn ? 'Keep fingers on the screen' : 'Держите пальцы на экране';
  static String get gameSelecting =>
      AppLocale.isEn ? 'Game is picking a player' : 'Игра выбирает игрока';
  static String get revealingResult =>
      AppLocale.isEn ? 'Revealing result' : 'Открываю результат';
  static String get placeFingers =>
      AppLocale.isEn ? 'Place fingers' : 'Приложите пальцы';
  static String hiddenHint(int max) => AppLocale.isEn
      ? '2 to $max players. The challenge reveals only after the pick.'
      : 'От 2 до $max игроков. Челлендж откроется только после выбора.';
  static String customHint(int max) => AppLocale.isEn
      ? '2 to $max players. Hold until the game picks one.'
      : 'От 2 до $max игроков. Держите пальцы, пока игра не выберет одного.';
  static String get secret => AppLocale.isEn ? 'secret' : 'секрет';
  static String player(int slot) =>
      AppLocale.isEn ? 'Player $slot' : 'Игрок $slot';

  // Result screen
  static String get youAreChosen =>
      AppLocale.isEn ? "you're chosen" : 'ты выбран';
  static String get youPay => AppLocale.isEn ? 'you pay' : 'ты платишь';
  static String get performs => AppLocale.isEn ? 'Performs' : 'Выполняет';
  static String get pays => AppLocale.isEn ? 'Pays' : 'Платит';
  static String get hiddenChallenge =>
      AppLocale.isEn ? 'Hidden challenge' : 'Скрытый челлендж';
  static String get task => AppLocale.isEn ? 'Task' : 'Задание';
  static String get payScenario =>
      AppLocale.isEn ? 'Pay scenario' : 'Сценарий оплаты';
  static String get playAgain => AppLocale.isEn ? 'Play again' : 'Сыграть ещё раз';
  static String get chooseModeBtnLabel =>
      AppLocale.isEn ? 'Choose mode' : 'Выбрать режим';
  static String get newTask => AppLocale.isEn ? 'New task' : 'Новое задание';
  static String get home => AppLocale.isEn ? 'Home' : 'Домой';

  // Task input
  static String get customTaskTitle =>
      AppLocale.isEn ? 'Custom task' : 'Своё задание';
  static String get customTaskHint => AppLocale.isEn
      ? 'Secondary mode. Use it to set your own scenario instead of hidden challenges.'
      : 'Это вторичный режим. Используй его, если хочешь задать свой сценарий вручную вместо скрытых челленджей.';
  static String get inputPlaceholder => AppLocale.isEn
      ? 'E.g.: Someone sings without music, gives a toast, or grabs snacks.'
      : 'Например: Кто-то поёт без музыки, говорит тост или идёт за снеками.';
  static String get quickExamples =>
      AppLocale.isEn ? 'Quick examples' : 'Быстрые примеры';
  static String get randomBtn => AppLocale.isEn ? 'Random' : 'Случайный';
  static String get continueBtn => AppLocale.isEn ? 'Continue' : 'Продолжить';
}
