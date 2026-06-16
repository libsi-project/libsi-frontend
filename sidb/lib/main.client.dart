/// The entrypoint for the **client** environment.
///
/// The [main] method will only be executed on the client when loading the page.
library;

// Client-specific Jaspr import.
import 'package:jaspr/client.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/config/localization/localization_scope_component.dart';
import 'package:sidb/core/di/di.dart';
import 'app_runner.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.client.options.dart';

void main() {
  // Initializes the client environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultClientOptions,
  );
  configureDependencies();
  LocaleSettings.setLocale(AppLocale.ru);
  runApp(
    LocalizationScope(
      locale: LocaleSettings.currentLocale,
      child: const AppRunner(),
    ),
  );
}
