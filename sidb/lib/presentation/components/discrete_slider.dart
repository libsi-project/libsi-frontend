import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class DiscreteSlider extends StatelessComponent {
  const DiscreteSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChange,
    this.step = 1.0,
    this.disabled = false,
    this.id,
    this.label,
    this.classes,
    this.styles,
    super.key,
  }) : assert(min < max, 'DiscreteSlider min must be less than max.'),
       assert(step > 0, 'DiscreteSlider step must be greater than zero.'),
       assert(
         min > double.negativeInfinity && min < double.infinity,
         'DiscreteSlider min must be finite.',
       ),
       assert(
         max > double.negativeInfinity && max < double.infinity,
         'DiscreteSlider max must be finite.',
       ),
       assert(
         step > double.negativeInfinity && step < double.infinity,
         'DiscreteSlider step must be finite.',
       ),
       assert(value >= min && value <= max, 'DiscreteSlider value must be inside min and max.');

  final double value;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChange;
  final bool disabled;
  final String? id;
  final String? label;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.discrete-slider').styles(
      display: Display.flex,
      width: 100.percent,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.65.rem),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontWeight: FontWeight.w800,
    ),
    css('.discrete-slider-header').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
    ),
    css('.discrete-slider-label').styles(
      color: AppTheme.textSecondary,
      fontSize: 0.9.rem,
      raw: {'text-transform': 'uppercase', 'letter-spacing': '0.04em'},
    ),
    css('.discrete-slider-value').styles(
      minWidth: 3.rem,
      padding: Padding.symmetric(horizontal: 0.55.rem, vertical: 0.25.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      color: AppTheme.onAccentColor,
      textAlign: TextAlign.center,
      fontSize: 0.9.rem,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.discrete-slider-control').styles(
      width: 100.percent,
      height: 1.4.rem,
      margin: Margin.zero,
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      raw: {
        '-webkit-appearance': 'none',
        'appearance': 'none',
        'background': 'transparent',
        'outline': 'none',
        '--discrete-slider-progress': '0%',
      },
    ),
    css('.discrete-slider-control:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '6px'},
    ),
    css('.discrete-slider-control::-webkit-slider-runnable-track').styles(
      height: 0.8.rem,
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      raw: {
        'background':
            'linear-gradient(90deg, var(--theme-primary) 0%, var(--theme-primary) var(--discrete-slider-progress), var(--theme-input-bg) var(--discrete-slider-progress), var(--theme-input-bg) 100%)',
      },
    ),
    css('.discrete-slider-control::-moz-range-track').styles(
      height: 0.8.rem,
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      raw: {
        'background':
            'linear-gradient(90deg, var(--theme-primary) 0%, var(--theme-primary) var(--discrete-slider-progress), var(--theme-input-bg) var(--discrete-slider-progress), var(--theme-input-bg) 100%)',
      },
    ),
    css('.discrete-slider-control::-webkit-slider-thumb').styles(
      width: 1.55.rem,
      height: 1.55.rem,
      margin: Margin.only(top: (-0.45).rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      backgroundColor: AppTheme.accentColor,
      raw: {'-webkit-appearance': 'none', 'appearance': 'none'},
    ),
    css('.discrete-slider-control::-moz-range-thumb').styles(
      width: 1.55.rem,
      height: 1.55.rem,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      backgroundColor: AppTheme.accentColor,
    ),
    css('.discrete-slider-control:active::-webkit-slider-thumb').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      transform: Transform.translate(x: 2.px, y: 2.px),
    ),
    css('.discrete-slider-control:active::-moz-range-thumb').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      transform: Transform.translate(x: 2.px, y: 2.px),
    ),
    css('.discrete-slider-ticks').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      color: AppTheme.textSecondary,
      fontSize: 0.75.rem,
      fontWeight: FontWeight.w800,
      raw: {'letter-spacing': '0.02em'},
    ),
    css('.discrete-slider-disabled').styles(
      opacity: 0.5,
      cursor: Cursor.notAllowed,
    ),
    css('.discrete-slider-disabled .discrete-slider-control').styles(
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final snappedValue = _snap(value);
    final percent = ((snappedValue - min) / (max - min) * 100).clamp(0, 100);
    final formattedValue = _format(snappedValue);

    return div(
      classes: [
        'discrete-slider',
        if (disabled) 'discrete-slider-disabled',
        if (classes != null) classes!,
      ].join(' '),
      styles: styles,
      [
        div(classes: 'discrete-slider-header', [
          span(classes: 'discrete-slider-label', [.text(label ?? 'Value')]),
          span(
            classes: 'discrete-slider-value',
            attributes: {if (id != null) 'for': id!},
            [.text(formattedValue)],
          ),
        ]),
        input<num>(
          id: id,
          type: InputType.range,
          value: formattedValue,
          disabled: disabled,
          classes: 'discrete-slider-control',
          attributes: {
            'min': _format(min),
            'max': _format(max),
            'step': _format(step),
            'aria-valuemin': _format(min),
            'aria-valuemax': _format(max),
            'aria-valuenow': formattedValue,
            'aria-valuetext': formattedValue,
            if (label != null) 'aria-label': label!,
          },
          styles: Styles(raw: {'--discrete-slider-progress': '$percent%'}),
          onInput: disabled ? null : (rawValue) => onChange(_snap(rawValue.toDouble())),
          onChange: disabled ? null : (rawValue) => onChange(_snap(rawValue.toDouble())),
        ),
        div(classes: 'discrete-slider-ticks', [
          span([.text(_format(min))]),
          span([.text(_format(max))]),
        ]),
      ],
    );
  }

  double _snap(double rawValue) {
    final steps = ((rawValue - min) / step).round();
    final snapped = min + steps * step;
    final clamped = math.min(max, math.max(min, snapped));
    final precision = math.max(_decimalPlaces(min), math.max(_decimalPlaces(max), _decimalPlaces(step)));
    return double.parse(clamped.toStringAsFixed(precision));
  }

  String _format(double rawValue) {
    final precision = math.max(_decimalPlaces(min), math.max(_decimalPlaces(max), _decimalPlaces(step)));
    if (precision == 0) return rawValue.toStringAsFixed(0);
    return rawValue.toStringAsFixed(precision).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  int _decimalPlaces(double rawValue) {
    final text = rawValue.toString();
    if (!text.contains('.')) return 0;
    return text.split('.').last.length;
  }
}
