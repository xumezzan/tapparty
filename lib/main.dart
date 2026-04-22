import 'package:flutter/widgets.dart';

import 'app.dart';
import 'l10n/app_locale.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.initialize();
  runApp(const TapPartyApp());
}
