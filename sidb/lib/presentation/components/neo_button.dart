import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

enum NeoButtonVariant { surface, primary, accent, ghost, danger, success, user }

enum NeoButtonSize { sm, md, lg }

enum NeoIconButtonShape { square, pill }

class NeoButton extends StatelessComponent {
  const NeoButton({
    required this.children,
    this.variant = NeoButtonVariant.surface,
    this.size = NeoButtonSize.md,
    this.classes,
    this.styles,
    this.attributes,
    this.disabled = false,
    this.onClick,
    super.key,
  });

  final List<Component> children;
  final NeoButtonVariant variant;
  final NeoButtonSize size;
  final String? classes;
  final Styles? styles;
  final Map<String, String>? attributes;
  final bool disabled;
  final VoidCallback? onClick;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-button').styles(
      display: Display.inlineFlex,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(),
      transform: Transform.translate(x: 0.px, y: 0.px),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontWeight: FontWeight.w800,
      textDecoration: TextDecoration.none,
      raw: {'outline': 'none'},
    ),
    css('.neo-button:hover').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      transform: Transform.translate(x: 2.px, y: 2.px),
    ),
    css('.neo-button:active').styles(
      shadow: NeoTokens.shadow(offset: 0),
      transform: Transform.translate(x: 3.px, y: 3.px),
    ),
    css('.neo-button:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.neo-button-disabled').styles(
      opacity: 0.5,
      cursor: Cursor.notAllowed,
      transform: Transform.translate(x: 0.px, y: 0.px),
    ),
    css('.neo-button-ghost').styles(
      border: NeoTokens.border(color: Colors.transparent),
      shadow: BoxShadow.none,
      backgroundColor: Colors.transparent,
    ),
    css('.neo-button-sm').styles(
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.4.rem),
      fontSize: 0.875.rem,
    ),
    css('.neo-button-md').styles(
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
      fontSize: 1.rem,
    ),
    css('.neo-button-lg').styles(
      padding: Padding.symmetric(horizontal: 1.5.rem, vertical: 0.85.rem),
      fontSize: 1.125.rem,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final resolvedAttributes = <String, String>{
      ...?attributes,
      'type': attributes?['type'] ?? 'button',
      if (disabled) 'disabled': '',
      if (disabled) 'aria-disabled': 'true',
    };

    return button(
      classes: [
        'neo-button',
        'neo-button-${size.name}',
        if (variant == NeoButtonVariant.ghost) 'neo-button-ghost',
        if (disabled) 'neo-button-disabled',
        ?classes,
      ].join(' '),
      styles: _variantStyles(variant).combine(styles ?? Styles()),
      attributes: resolvedAttributes,
      onClick: disabled ? null : onClick,
      children,
    );
  }

  static Styles _variantStyles(NeoButtonVariant variant) {
    return switch (variant) {
      NeoButtonVariant.primary => Styles(
        color: AppTheme.onPrimaryColor,
        backgroundColor: AppTheme.primaryColor,
      ),
      NeoButtonVariant.accent => Styles(
        color: AppTheme.onAccentColor,
        backgroundColor: AppTheme.accentColor,
      ),
      NeoButtonVariant.ghost => Styles(
        color: AppTheme.textColor,
        backgroundColor: Colors.transparent,
      ),
      NeoButtonVariant.danger => Styles(
        color: AppTheme.onPrimaryColor,
        backgroundColor: AppTheme.errorColor,
      ),
      NeoButtonVariant.success => Styles(
        color: AppTheme.onAccentColor,
        backgroundColor: AppTheme.successColor,
      ),
      NeoButtonVariant.user => Styles(
        color: AppTheme.textColor,
        backgroundColor: AppTheme.userButton,
      ),
      NeoButtonVariant.surface => Styles(
        color: AppTheme.textColor,
        backgroundColor: AppTheme.surfaceColor,
      ),
    };
  }
}

class NeoIconButton extends StatelessComponent {
  const NeoIconButton({
    required this.child,
    this.variant = NeoButtonVariant.surface,
    this.shape = NeoIconButtonShape.pill,
    this.size = 44,
    this.classes,
    this.styles,
    this.attributes,
    this.disabled = false,
    this.onClick,
    super.key,
  });

  final Component child;
  final NeoButtonVariant variant;
  final NeoIconButtonShape shape;
  final double size;
  final String? classes;
  final Styles? styles;
  final Map<String, String>? attributes;
  final bool disabled;
  final VoidCallback? onClick;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-icon-button span').styles(
      display: Display.flex,
      transition: NeoTokens.transition(),
      transform: Transform.rotate(0.deg),
    ),
    css('.neo-icon-button:hover span').styles(
      transform: Transform.rotate(15.deg),
    ),
  ];

  @override
  Component build(BuildContext context) {
    return NeoButton(
      variant: variant,
      disabled: disabled,
      onClick: onClick,
      attributes: attributes,
      classes: ['neo-icon-button', ?classes].join(' '),
      styles: Styles(
        width: size.px,
        height: size.px,
        padding: Padding.zero,
        radius: NeoTokens.radius(shape == NeoIconButtonShape.pill ? NeoTokens.radiusPill : NeoTokens.radiusSm),
      ).combine(styles ?? Styles()),
      children: [
        span([child]),
      ],
    );
  }
}
