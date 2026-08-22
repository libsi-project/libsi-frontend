import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class Checkbox extends StatelessComponent {
  const Checkbox({
    required this.checked,
    required this.onChange,
    this.label,
    this.disabled = false,
    this.id,
    this.classes,
    this.styles,
    super.key,
  });

  final bool checked;
  final ValueChanged<bool> onChange;
  final Component? label;
  final bool disabled;
  final String? id;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-checkbox').styles(
      display: Display.inlineFlex,
      padding: Padding.zero,
      border: Border.none,
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.center,
      gap: Gap.all(0.7.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.left,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.neo-checkbox-box').styles(
      display: Display.inlineFlex,
      width: 1.75.rem,
      height: 1.75.rem,
      border: NeoTokens.border(width: NeoTokens.borderStrong),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowMd),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.translate(x: 0.px, y: 0.px),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.inputBackground,
      raw: {'align-self': 'center', 'flex-shrink': '0'},
    ),
    css('.neo-checkbox:hover .neo-checkbox-box').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      transform: Transform.translate(x: 1.px, y: 1.px),
    ),
    css('.neo-checkbox:active .neo-checkbox-box').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      transform: Transform.translate(x: 3.px, y: 3.px),
    ),
    css('.neo-checkbox:focus-visible .neo-checkbox-box').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.neo-checkbox-checked .neo-checkbox-box').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      transform: Transform.translate(x: 2.px, y: 2.px),
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.neo-checkbox-check').styles(
      opacity: 0,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.scale(0.6),
      fontSize: 1.1.rem,
      fontWeight: FontWeight.w900,
      lineHeight: 1.em,
    ),
    css('.neo-checkbox-checked .neo-checkbox-check').styles(
      opacity: 1,
      transform: Transform.scale(1),
    ),
    css('.neo-checkbox-label').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      lineHeight: 1.25.em,
      raw: {'align-self': 'center'},
    ),
    css('.neo-checkbox-disabled').styles(
      opacity: 0.5,
      cursor: Cursor.notAllowed,
    ),
    css('.neo-checkbox-disabled .neo-checkbox-box').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      transform: Transform.translate(x: 0.px, y: 0.px),
    ),
  ];

  @override
  Component build(BuildContext context) {
    return button(
      id: id,
      type: ButtonType.button,
      disabled: disabled,
      classes: [
        'neo-checkbox',
        if (checked) 'neo-checkbox-checked',
        if (disabled) 'neo-checkbox-disabled',
        if (classes != null) classes!,
      ].join(' '),
      styles: styles,
      attributes: {
        'role': 'checkbox',
        'aria-checked': checked ? 'true' : 'false',
        if (disabled) 'aria-disabled': 'true',
      },
      onClick: disabled ? null : () => onChange(!checked),
      [
        span(classes: 'neo-checkbox-box', [
          span(classes: 'neo-checkbox-check', [.text('✓')]),
        ]),
        if (label != null) span(classes: 'neo-checkbox-label', [label!]),
      ],
    );
  }
}
