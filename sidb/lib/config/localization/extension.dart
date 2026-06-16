import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/config/localization/localization_scope_component.dart';

extension LocalizationContext on BuildContext {
  AppLocale get locale => LocalizationScope.of(this).locale;
  Translations get l10n => LocalizationScope.of(this).translations;
}
