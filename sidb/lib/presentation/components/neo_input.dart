import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
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
        'box-shadow': '3px 3px 0 0 var(--neo-input-shadow-color)',
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

/// Search input with a clickable lupe icon.
///
/// Search is triggered only on `Enter` (form submit) or a click on the
/// lupe icon — never on every keystroke. Owns its query text; seed it
/// with [initialValue] (for example from the URL) and read the submitted
/// query via [onSubmit]. Optional [onChange] observes keystrokes.
class SearchField extends StatefulComponent {
  const SearchField({
    this.placeholder,
    this.initialValue,
    this.id,
    this.classes,
    this.styles,
    this.inputStyles,
    this.iconStyles,
    this.attributes,
    this.onSubmit,
    this.onChange,
    this.searchLabel = 'Search',
    super.key,
  });

  final String? placeholder;
  final String? initialValue;
  final String? id;
  final String? classes;
  final Styles? styles;
  final Styles? inputStyles;
  final Styles? iconStyles;
  final Map<String, String>? attributes;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChange;
  final String searchLabel;

  @css
  static List<StyleRule> get stylesheets => [
    css('.search-field').styles(
      display: Display.block,
      position: Position.relative(),
      width: 100.percent,
      margin: Margin.zero,
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
      position: Position.absolute(top: 50.percent, left: 0.45.rem),
      width: 28.px,
      height: 28.px,
      padding: Padding.zero,
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.translate(y: (-50).percent),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textSecondary,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.search-field-icon:hover').styles(
      color: AppTheme.textColor,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.search-field-icon:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
  ];

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late String _query = component.initialValue ?? '';

  @override
  void didUpdateComponent(covariant SearchField oldComponent) {
    super.didUpdateComponent(oldComponent);
    // Keep the input synced with the URL when a search is actually
    // active. Leaving /search must not reset what the user typed, so
    // we only overwrite when the incoming query is non-null.
    final incoming = component.initialValue;
    if (incoming != null && incoming != oldComponent.initialValue && incoming != _query) {
      _query = incoming;
    }
  }

  void _onInput(web.Event event) {
    final value = (event.target as web.HTMLInputElement).value;
    if (value == _query) return;
    setState(() => _query = value);
    component.onChange?.call(value);
  }

  void _onSubmit(web.Event event) {
    event.preventDefault();
    component.onSubmit?.call(_query.trim());
  }

  @override
  Component build(BuildContext context) {
    return form(
      classes: [
        'search-field',
        ?component.classes,
      ].join(' '),
      styles: component.styles,
      attributes: const {'role': 'search'},
      events: {'submit': _onSubmit},
      [
        NeoInput(
          id: component.id,
          type: 'search',
          placeholder: component.placeholder,
          value: _query.isEmpty ? null : _query,
          attributes: {
            'aria-label': component.placeholder ?? component.searchLabel,
            'name': 'q',
            'autocomplete': 'off',
            'enterkeyhint': 'search',
            ...?component.attributes,
          },
          styles: component.inputStyles,
          onInput: _onInput,
        ),
        button(
          classes: 'search-field-icon',
          type: ButtonType.submit,
          styles: component.iconStyles,
          attributes: {'aria-label': component.searchLabel},
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
