import 'package:jaspr/dom.dart';

/// Application color theme using CSS variables for instant switching
class AppTheme {
  final Color primary;
  final Color accent;
  final Color userBtn;
  final Color inputBg;
  final Color border;
  final Color text;
  final Color textLink;
  final Color textSec;
  final Color surface;
  final Color canvas;
  final Color badgeStudent;
  final Color badgeHardcore;
  final Color badgeThematic;
  final Color badgeGeneral;
  final Color badgeNeutral;

  const AppTheme({
    required this.primary,
    required this.accent,
    required this.userBtn,
    required this.inputBg,
    required this.border,
    required this.text,
    required this.textLink,
    required this.textSec,
    required this.surface,
    required this.canvas,
    required this.badgeStudent,
    required this.badgeHardcore,
    required this.badgeThematic,
    required this.badgeGeneral,
    required this.badgeNeutral,
  });

  /// The shared theme instance that uses CSS variables
  static const theme = AppTheme(
    primary: Color('var(--theme-primary)'),
    accent: Color('var(--theme-accent)'),
    userBtn: Color('var(--theme-user-btn)'),
    inputBg: Color('var(--theme-input-bg)'),
    border: Color('var(--theme-border)'),
    text: Color('var(--theme-text)'),
    textLink: Color('var(--theme-text-link)'),
    textSec: Color('var(--theme-text-sec)'),
    surface: Color('var(--theme-surface)'),
    canvas: Color('var(--theme-canvas)'),
    badgeStudent: Color('var(--theme-badge-student)'),
    badgeHardcore: Color('var(--theme-badge-hardcore)'),
    badgeThematic: Color('var(--theme-badge-thematic)'),
    badgeGeneral: Color('var(--theme-badge-general)'),
    badgeNeutral: Color('var(--theme-badge-neutral)'),
  );

  // Keep these for background initialization/fallback if needed
  static final light = theme;
  static final dark = theme;
}
