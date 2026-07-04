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
  final Color error;
  final Color success;
  final Color onPrimary;
  final Color onAccent;

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
    required this.error,
    required this.success,
    required this.onPrimary,
    required this.onAccent,
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
    error: Color('var(--theme-error)'),
    success: Color('var(--theme-success)'),
    onPrimary: Color('var(--theme-on-primary)'),
    onAccent: Color('var(--theme-on-accent)'),
  );

  static const primaryColor = Color('var(--theme-primary)');
  static const accentColor = Color('var(--theme-accent)');
  static const userButton = Color('var(--theme-user-btn)');
  static const inputBackground = Color('var(--theme-input-bg)');
  static const borderColor = Color('var(--theme-border)');
  static const textColor = Color('var(--theme-text)');
  static const textLinkColor = Color('var(--theme-text-link)');
  static const textSecondary = Color('var(--theme-text-sec)');
  static const surfaceColor = Color('var(--theme-surface)');
  static const canvasColor = Color('var(--theme-canvas)');
  static const badgeStudentColor = Color('var(--theme-badge-student)');
  static const badgeHardcoreColor = Color('var(--theme-badge-hardcore)');
  static const badgeThematicColor = Color('var(--theme-badge-thematic)');
  static const badgeGeneralColor = Color('var(--theme-badge-general)');
  static const badgeNeutralColor = Color('var(--theme-badge-neutral)');
  static const errorColor = Color('var(--theme-error)');
  static const successColor = Color('var(--theme-success)');
  static const onPrimaryColor = Color('var(--theme-on-primary)');
  static const onAccentColor = Color('var(--theme-on-accent)');

  // Keep these for background initialization/fallback if needed
  static final light = theme;
  static final dark = theme;
}
