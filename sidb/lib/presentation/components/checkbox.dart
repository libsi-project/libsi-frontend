import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/icon.dart';
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
      appearance: Appearance.none,
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
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
      width: 1.5.rem,
      height: 1.5.rem,
      boxSizing: BoxSizing.borderBox,
      border: NeoTokens.border(),
      radius: NeoTokens.radius(0),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.neo-checkbox:hover .neo-checkbox-box').styles(
      backgroundColor: AppTheme.inputBackground,
    ),
    css('.neo-checkbox:focus-visible .neo-checkbox-box').styles(
      outline: Outline(
        color: AppTheme.primaryColor,
        style: OutlineStyle.solid,
        width: OutlineWidth(2.px),
        offset: 2.px,
      ),
    ),
    css('.neo-checkbox-checked .neo-checkbox-box').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.neo-checkbox-checked:hover .neo-checkbox-box').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.neo-checkbox-check').styles(
      display: Display.flex,
      opacity: 0,
      pointerEvents: PointerEvents.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.scale(0.7),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
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
    css('.neo-checkbox-disabled:hover .neo-checkbox-box').styles(
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.neo-checkbox-disabled.neo-checkbox-checked:hover .neo-checkbox-box').styles(
      backgroundColor: AppTheme.primaryColor,
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
        ?classes,
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
          span(classes: 'neo-checkbox-check', [
            const AppIcon(
              IconPaths.check,
              width: 16,
              height: 16,
              strokeWidth: '3',
              strokeColor: AppTheme.onPrimaryColor,
            ),
          ]),
        ]),
        if (label != null) span(classes: 'neo-checkbox-label', [label!]),
      ],
    );
  }
}
