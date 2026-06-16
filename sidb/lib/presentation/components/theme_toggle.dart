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

  @override
  Component build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        final theme = state == ThemeMode.light ? AppTheme.light : AppTheme.dark;

        return button(
          id: 'theme-toggle',
          styles: Styles(
            display: Display.inlineFlex,
            width: 44.px,
            height: 44.px,
            border: Border.all(width: 2.px, color: theme.border),
            radius: BorderRadius.circular(100.px),
            shadow: BoxShadow(
              offsetX: 3.px,
              offsetY: 3.px,
              color: theme.border,
            ),
            justifyContent: JustifyContent.center,
            alignItems: AlignItems.center,
            backgroundColor: theme.accent,
            cursor: Cursor.pointer,
            raw: {'user-select': 'none', 'text-decoration': 'none'},
          ),
          onClick: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
          [
            span(
              styles: Styles(display: Display.flex),
              [
              Icon(
                state == ThemeMode.light ? _sunPath : _moonPath,
                classes: 'h-6 w-6',
                strokeWidth: '2.5',
              ),
            ]),
          ],
        );
      },
    );
  }

  static const String _sunPath =
      'M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z';

  static const String _moonPath = 'M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z';
}
