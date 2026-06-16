import 'package:jaspr/jaspr.dart';

import 'l10n/l10n.g.dart';

class LocalizationScope extends InheritedComponent {
  const LocalizationScope({
    required this.locale,
    required super.child,
    super.key,
  });

  final AppLocale locale;

  Translations get translations => locale.translations;

  static LocalizationScope of(BuildContext context) {
    final scope = context.dependOnInheritedComponentOfExactType<LocalizationScope>();
    if (scope == null) {
      throw StateError('No LocalizationScope found in BuildContext.');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(covariant LocalizationScope oldComponent) {
    return locale != oldComponent.locale;
  }
}
