import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart' hide Transition;
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/theme_cubit.dart';

/// A client-side component that toggles the application theme between light and dark modes.
/// It persists the chosen theme in the browser's local storage.
class ThemeToggle extends StatelessComponent {
  const ThemeToggle({super.key});

  @css
  static List<StyleRule> get stylesheets => [
    css('.theme-toggle').styles(
      display: Display.inlineFlex,
      width: 36.px,
      height: 36.px,
      padding: Padding.zero,
      border: Border.none,
      radius: BorderRadius.circular(0.px),
      cursor: Cursor.pointer,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      backgroundColor: Colors.transparent,
      raw: {
        'box-shadow': 'none',
        'outline': 'none',
        'transform': 'none',
      },
    ),
    css('.theme-toggle:hover').styles(
      border: Border.none,
      backgroundColor: AppTheme.accentColor,
      raw: {
        'box-shadow': 'none',
        'transform': 'none',
      },
    ),
    css('[data-theme="dark"] .theme-toggle:hover').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.theme-toggle:active').styles(
      raw: {
        'box-shadow': 'none',
        'transform': 'none',
      },
    ),
    css('.theme-toggle:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
  ];

  @override
  Component build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return button(
          classes: 'theme-toggle',
          attributes: const {
            'id': 'theme-toggle',
            'type': 'button',
            'aria-label': 'Toggle theme',
          },
          onClick: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
          [
            AppIcon(
              state == ThemeMode.light ? _sunPath : _moonPath,
              width: 20,
              height: 20,
              strokeWidth: '2.5',
            ),
          ],
        );
      },
    );
  }

  static const String _sunPath =
      'M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z';

  static const String _moonPath = 'M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z';
}
