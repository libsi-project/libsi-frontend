import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

enum NeoInputState { normal, error, success }

class NeoInput extends StatelessComponent {
  const NeoInput({
    this.type = 'text',
    this.placeholder,
    this.value,
    this.disabled = false,
    this.readOnly = false,
    this.state = NeoInputState.normal,
    this.id,
    this.classes,
    this.styles,
    this.attributes,
    this.onInput,
    this.onChange,
    super.key,
  });

  final String type;
  final String? placeholder;
  final String? value;
  final bool disabled;
  final bool readOnly;
  final NeoInputState state;
  final String? id;
  final String? classes;
  final Styles? styles;
  final Map<String, String>? attributes;
  final EventCallback? onInput;
  final EventCallback? onChange;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-input').styles(
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
      border: NeoTokens.border(color: const Color('var(--neo-input-border-color)')),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.inputBackground,
      raw: {
        '--neo-input-border-color': 'var(--theme-border)',
        '--neo-input-shadow-color': 'var(--theme-border)',
        '--neo-input-border-width': '2px',
        'border-width': 'var(--neo-input-border-width)',
        'box-shadow': '4px 4px 0 0 var(--neo-input-shadow-color)',
        'outline': 'none',
      },
    ),
    css('.neo-input::placeholder').styles(
      opacity: 0.75,
      color: AppTheme.textSecondary,
    ),
    css('.neo-input:focus').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      raw: {'box-shadow': '3px 3px 0 0 var(--neo-input-shadow-color)'},
    ),
    css('.neo-input-error').styles(
      raw: {
        '--neo-input-border-color': 'var(--theme-error)',
        '--neo-input-shadow-color': 'var(--theme-error)',
        '--neo-input-border-width': '4px',
      },
    ),
    css('.neo-input-success').styles(
      raw: {
        '--neo-input-border-color': 'var(--theme-success)',
        '--neo-input-shadow-color': 'var(--theme-success)',
        '--neo-input-border-width': '4px',
      },
    ),
    css('.neo-input-disabled').styles(
      opacity: 0.5,
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final resolvedAttributes = <String, String>{
      ...?attributes,
      'type': type,
      'placeholder': ?placeholder,
      'value': ?value,
      if (disabled) 'disabled': '',
      if (disabled) 'aria-disabled': 'true',
      if (readOnly) 'readonly': '',
    };

    final eventMap = <String, EventCallback>{};
    if (onInput != null) eventMap['input'] = onInput!;
    if (onChange != null) eventMap['change'] = onChange!;

    return input(
      id: id,
      classes: [
        'neo-input',
        if (disabled) 'neo-input-disabled',
        if (state == NeoInputState.error) 'neo-input-error',
        if (state == NeoInputState.success) 'neo-input-success',
        ?classes,
      ].join(' '),
      styles: styles,
      attributes: resolvedAttributes,
      events: eventMap.isNotEmpty ? eventMap : null,
    );
  }
}

class SearchField extends StatelessComponent {
  const SearchField({
    this.placeholder,
    this.value,
    this.id,
    this.classes,
    this.styles,
    this.inputStyles,
    this.iconStyles,
    this.attributes,
    this.onInput,
    this.onChange,
    super.key,
  });

  final String? placeholder;
  final String? value;
  final String? id;
  final String? classes;
  final Styles? styles;
  final Styles? inputStyles;
  final Styles? iconStyles;
  final Map<String, String>? attributes;
  final EventCallback? onInput;
  final EventCallback? onChange;

  @css
  static List<StyleRule> get stylesheets => [
    css('.search-field').styles(
      position: Position.relative(),
      width: 100.percent,
      transition: NeoTokens.transition(NeoTokens.motionSlowMs),
    ),
    css('.search-field .neo-input').styles(
      height: 36.px,
      padding: Padding.only(
        left: 2.75.rem,
        right: 1.rem,
        top: 0.px,
        bottom: 0.px,
      ),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      transition: NeoTokens.transition(NeoTokens.motionSlowMs),
      fontSize: 15.px,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.search-field:focus-within').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
    ),
    css('.search-field:focus-within .neo-input').styles(
      transform: Transform.translate(x: 0.px, y: 0.px),
    ),
    css('.search-field-icon').styles(
      display: Display.flex,
      position: Position.absolute(top: 50.percent, left: 0.9.rem),
      pointerEvents: PointerEvents.none,
      transform: Transform.translate(y: (-50).percent),
      color: AppTheme.textSecondary,
    ),
  ];

  @override
  Component build(BuildContext context) {
    return div(
      classes: [
        'search-field',
        ?classes,
      ].join(' '),
      styles: styles,
      [
        NeoInput(
          id: id,
          type: 'search',
          placeholder: placeholder,
          value: value,
          attributes: {
            'aria-label': placeholder ?? 'Search',
            ...?attributes,
          },
          styles: inputStyles,
          onInput: onInput,
          onChange: onChange,
        ),
        span(
          classes: 'search-field-icon',
          styles: iconStyles,
          [
            const AppIcon(
              IconPaths.search,
              width: 18,
              height: 18,
              strokeColor: AppTheme.textSecondary,
            ),
          ],
        ),
      ],
    );
  }
}
