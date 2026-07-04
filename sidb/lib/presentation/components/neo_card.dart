import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/neo_surface.dart';
import 'package:sidb/presentation/theme/app_theme.dart';

class NeoCard extends StatelessComponent {
  const NeoCard({
    required this.children,
    this.classes,
    this.styles,
    this.interactive = true,
    this.shadowColorCss = 'var(--theme-border)',
    super.key,
  });

  final List<Component> children;
  final String? classes;
  final Styles? styles;
  final bool interactive;
  final String shadowColorCss;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-card').styles(
      display: Display.flex,
      padding: Padding.all(1.rem),
      flexDirection: FlexDirection.column,
      color: AppTheme.textColor,
    ),
  ];

  @override
  Component build(BuildContext context) {
    return NeoSurface(
      interactive: interactive,
      classes: ['neo-card', if (classes != null) classes!].join(' '),
      styles: styles,
      shadowColorCss: shadowColorCss,
      children: children,
    );
  }
}
