import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/neo_input.dart';

/// Lightweight style token for the [Input] component.
@immutable
class InputStyle {
  final Styles styles;
  final NeoInputState state;

  const InputStyle(this.styles) : state = NeoInputState.normal;
  const InputStyle.state(this.state) : styles = const Styles();
}

/// Backwards-compatible wrapper around [NeoInput].
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

  @override
  Component build(BuildContext context) {
    Styles resolvedStyles = Styles();
    var state = NeoInputState.normal;

    if (style != null) {
      for (final item in style!) {
        resolvedStyles = resolvedStyles.combine(item.styles);
        if (item.state != NeoInputState.normal) {
          state = item.state;
        }
      }
    }
    if (inlineStyles != null) {
      resolvedStyles = resolvedStyles.combine(inlineStyles!);
    }

    return NeoInput(
      id: id,
      type: type,
      placeholder: placeholder,
      value: value,
      disabled: disabled,
      state: state,
      classes: classes,
      styles: resolvedStyles,
      attributes: attributes,
      onInput: onInput,
      onChange: onChange,
    );
  }

  static const InputStyle error = InputStyle.state(NeoInputState.error);
  static const InputStyle success = InputStyle.state(NeoInputState.success);
}
