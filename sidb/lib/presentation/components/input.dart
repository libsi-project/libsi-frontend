import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Lightweight style token for the [Input] component.
@immutable
class InputStyle {
  final Styles styles;
  const InputStyle(this.styles);
}

/// A simple neobrutalism-styled input component.
class Input extends StatelessComponent {
  const Input({
    this.type = 'text',
    this.placeholder,
    this.value,
    this.disabled = false,
    this.style,
    this.id,
    this.classes,
    this.inlineStyles,
    this.attributes,
    this.onInput,
    this.onChange,
    super.key,
  });

  final String type;
  final String? placeholder;
  final String? value;
  final bool disabled;
  final List<InputStyle>? style;
  final String? id;
  final String? classes;
  final Styles? inlineStyles;
  final Map<String, String>? attributes;
  final EventCallback? onInput;
  final EventCallback? onChange;

  static final Styles _baseStyle = Styles(
    width: 100.percent,
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
    border: Border.all(width: 2.px, color: const Color('var(--theme-border)')),
    radius: BorderRadius.circular(6.px),
    shadow: BoxShadow(
      offsetX: 4.px,
      offsetY: 4.px,
      blur: 0.px,
      spread: 0.px,
      color: const Color('var(--theme-border)'),
    ),
    transition: Transition('all', duration: 100.ms),
    color: const Color('var(--theme-text)'),
    fontFamily: const FontFamily('Arial'),
    fontSize: 1.rem,
    fontWeight: FontWeight.w700,
    backgroundColor: const Color('var(--theme-input-bg)'),
    raw: {'outline': 'none'},
  );

  @override
  Component build(BuildContext context) {
    final resolvedAttributes = <String, String>{
      if (attributes != null) ...attributes!,
      'type': type,
    };

    if (placeholder != null) {
      resolvedAttributes['placeholder'] = placeholder!;
    }

    if (value != null) {
      resolvedAttributes['value'] = value!;
    }

    if (disabled) {
      resolvedAttributes
        ..['disabled'] = ''
        ..['aria-disabled'] = 'true';
    }

    final eventMap = <String, EventCallback>{};
    if (onInput != null) {
      eventMap['input'] = onInput!;
    }
    if (onChange != null) {
      eventMap['change'] = onChange!;
    }

    Styles resolvedStyles = _baseStyle;
    if (style != null) {
      for (final item in style!) {
        resolvedStyles = resolvedStyles.combine(item.styles);
      }
    }
    if (disabled) {
      resolvedStyles = resolvedStyles.combine(
        Styles(
          opacity: 0.5,
          cursor: Cursor.notAllowed,
        ),
      );
    }
    if (inlineStyles != null) {
      resolvedStyles = resolvedStyles.combine(inlineStyles!);
    }

    return input(
      id: id,
      classes: classes,
      styles: resolvedStyles,
      attributes: resolvedAttributes,
      events: eventMap.isNotEmpty ? eventMap : null,
    );
  }

  static final InputStyle error = InputStyle(
    Styles(
      border: Border.all(width: 4.px, color: const Color('#FF3366')),
      shadow: BoxShadow(
        offsetX: 4.px,
        offsetY: 4.px,
        blur: 0.px,
        spread: 0.px,
        color: const Color('#FF3366'),
      ),
    ),
  );
  static final InputStyle success = InputStyle(
    Styles(
      border: Border.all(width: 4.px, color: const Color('#00FF7F')),
      shadow: BoxShadow(
        offsetX: 4.px,
        offsetY: 4.px,
        blur: 0.px,
        spread: 0.px,
        color: const Color('#00FF7F'),
      ),
    ),
  );
}
