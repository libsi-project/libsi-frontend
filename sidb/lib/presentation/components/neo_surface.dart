import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class NeoSurface extends StatelessComponent {
  const NeoSurface({
    required this.children,
    this.classes,
    this.styles,
    this.attributes,
    this.interactive = false,
    this.shadowColorCss = 'var(--theme-border)',
    super.key,
  });

  final List<Component> children;
  final String? classes;
  final Styles? styles;
  final Map<String, String>? attributes;
  final bool interactive;
  final String shadowColorCss;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-surface').styles(
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      transition: NeoTokens.transition(),
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        '--neo-surface-shadow-color': 'var(--theme-border)',
        'box-shadow': '6px 6px 0 0 var(--neo-surface-shadow-color)',
      },
    ),
    css('.neo-surface-interactive').styles(
      cursor: Cursor.pointer,
      transform: Transform.translate(x: 0.px, y: 0.px),
    ),
    css('.neo-surface-interactive:hover').styles(
      transform: Transform.translate(x: 2.px, y: 2.px),
      raw: {'box-shadow': '4px 4px 0 0 var(--neo-surface-shadow-color) !important'},
    ),
  ];

  @override
  Component build(BuildContext context) {
    return div(
      classes: [
        'neo-surface',
        if (interactive) 'neo-surface-interactive',
        ?classes,
      ].join(' '),
      styles: Styles(raw: {'--neo-surface-shadow-color': shadowColorCss}).combine(styles ?? Styles()),
      attributes: attributes,
      children,
    );
  }
}
