import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

enum SwitchToggleSize { md, sm }

/// Neobrutalist on/off switch: square track, sliding thumb, no drop shadow.
class SwitchToggle extends StatelessComponent {
  const SwitchToggle({
    required this.checked,
    required this.onChange,
    this.size = SwitchToggleSize.md,
    this.label,
    this.disabled = false,
    this.id,
    this.ariaLabel,
    this.classes,
    this.styles,
    super.key,
  });

  final bool checked;
  final ValueChanged<bool> onChange;
  final SwitchToggleSize size;
  final Component? label;
  final bool disabled;
  final String? id;
  final String? ariaLabel;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.switch-toggle').styles(
      display: Display.inlineFlex,
      padding: Padding.zero,
      border: Border.none,
      appearance: Appearance.none,
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
    css('.switch-toggle-track').styles(
      display: Display.inlineFlex,
      position: Position.relative(),
      width: 2.75.rem,
      height: 1.5.rem,
      boxSizing: BoxSizing.borderBox,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(0),
      appearance: Appearance.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      backgroundColor: Colors.transparent,
    ),
    css('.switch-toggle-sm .switch-toggle-track').styles(
      width: 2.25.rem,
      height: 1.25.rem,
    ),
    css('.switch-toggle-checked .switch-toggle-track').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.switch-toggle-track::after').styles(
      content: '',
      display: Display.block,
      position: Position.absolute(top: (-0.5).rem, right: (-0.75).rem, bottom: (-0.5).rem, left: (-0.75).rem),
    ),
    css('.switch-toggle:focus-visible .switch-toggle-track').styles(
      outline: Outline(
        color: AppTheme.primaryColor,
        style: OutlineStyle.solid,
        width: OutlineWidth(2.px),
        offset: 2.px,
      ),
    ),
    css('.switch-toggle-thumb').styles(
      display: Display.block,
      width: 1.rem,
      height: 1.rem,
      margin: Margin.symmetric(horizontal: 0.125.rem),
      boxSizing: BoxSizing.borderBox,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(0),
      pointerEvents: PointerEvents.none,
      transition: Transition('transform', duration: NeoTokens.motionNormalMs.ms),
      transform: Transform.translate(x: 0.px),
      flex: Flex(shrink: 0),
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.switch-toggle-sm .switch-toggle-thumb').styles(
      width: 0.75.rem,
      height: 0.75.rem,
    ),
    css('.switch-toggle-checked .switch-toggle-thumb').styles(
      transform: Transform.translate(x: 1.25.rem),
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.switch-toggle-sm.switch-toggle-checked .switch-toggle-thumb').styles(
      transform: Transform.translate(x: 1.rem),
    ),
    css('.switch-toggle-label').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      lineHeight: 1.25.em,
      raw: {'align-self': 'center'},
    ),
    css('.switch-toggle-disabled').styles(
      opacity: 0.5,
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  Component build(BuildContext context) {
    return button(
      id: id,
      type: ButtonType.button,
      disabled: disabled,
      classes: [
        'switch-toggle',
        if (size == SwitchToggleSize.sm) 'switch-toggle-sm',
        if (checked) 'switch-toggle-checked',
        if (disabled) 'switch-toggle-disabled',
        ?classes,
      ].join(' '),
      styles: styles,
      attributes: {
        'role': 'switch',
        'aria-checked': checked ? 'true' : 'false',
        'aria-label': ?ariaLabel,
        if (disabled) 'aria-disabled': 'true',
      },
      onClick: disabled ? null : () => onChange(!checked),
      [
        span(classes: 'switch-toggle-track', [
          span(classes: 'switch-toggle-thumb', []),
        ]),
        if (label != null) span(classes: 'switch-toggle-label', [label!]),
      ],
    );
  }
}
