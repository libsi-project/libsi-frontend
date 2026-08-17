import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';
import 'package:universal_web/web.dart' as web;

int _nextDropdownEditFieldId = 0;

class DropdownEditField<T> extends StatefulComponent {
  const DropdownEditField({
    required this.items,
    required this.value,
    required this.onChange,
    this.itemAsString,
    this.placeholder,
    this.disabled = false,
    this.id,
    this.classes,
    this.styles,
    super.key,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChange;
  final String Function(T)? itemAsString;
  final String? placeholder;
  final bool disabled;
  final String? id;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.dropdown-edit-field').styles(
      position: Position.relative(),
      width: 100.percent,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontWeight: FontWeight.w800,
    ),
    css('.dropdown-edit-field-control').styles(
      display: Display.flex,
      width: 100.percent,
      border: NeoTokens.border(color: const Color('var(--dropdown-edit-field-border-color)')),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
      backgroundColor: AppTheme.inputBackground,
      raw: {
        '--dropdown-edit-field-border-color': 'var(--theme-border)',
        '--dropdown-edit-field-shadow-color': 'var(--theme-border)',
        'box-shadow': '4px 4px 0 0 var(--dropdown-edit-field-shadow-color)',
      },
    ),
    css('.dropdown-edit-field-control:focus-within').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      raw: {'box-shadow': '3px 3px 0 0 var(--dropdown-edit-field-shadow-color)'},
    ),
    css('.dropdown-edit-field-input').styles(
      width: 100.percent,
      minWidth: 0.px,
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
      border: Border.none,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.dropdown-edit-field-input::placeholder').styles(
      opacity: 0.75,
      color: AppTheme.textSecondary,
    ),
    css('.dropdown-edit-field-clear').styles(
      display: Display.inlineFlex,
      width: 2.rem,
      height: 2.rem,
      padding: Padding.zero,
      margin: Margin.only(right: 0.35.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w900,
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.dropdown-edit-field-clear:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.dropdown-edit-field-menu').styles(
      display: Display.flex,
      position: Position.absolute(top: 100.percent, left: 0.px, right: 0.px),
      zIndex: ZIndex(20),
      maxHeight: 14.rem,
      padding: Padding.all(0.35.rem),
      margin: Margin.only(top: 0.55.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowMd),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.25.rem),
      backgroundColor: AppTheme.surfaceColor,
      raw: {'overflow-y': 'auto', 'list-style': 'none'},
    ),
    css('.dropdown-edit-field-option').styles(
      display: Display.flex,
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.55.rem),
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      textAlign: TextAlign.left,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: Colors.transparent,
    ),
    css('.dropdown-edit-field-option:hover, .dropdown-edit-field-option-highlighted').styles(
      border: NeoTokens.border(),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      transform: Transform.translate(x: 1.px, y: 1.px),
      backgroundColor: AppTheme.inputBackground,
    ),
    css('.dropdown-edit-field-option-selected').styles(
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.dropdown-edit-field-empty').styles(
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.7.rem),
      color: AppTheme.textSecondary,
      fontSize: 0.9.rem,
    ),
    css('.dropdown-edit-field-disabled').styles(
      opacity: 0.5,
    ),
    css('.dropdown-edit-field-disabled .dropdown-edit-field-input').styles(
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  State<DropdownEditField<T>> createState() => _DropdownEditFieldState<T>();
}

class _DropdownEditFieldState<T> extends State<DropdownEditField<T>> {
  late String _baseId;
  late String _query;
  bool _isOpen = false;
  int _highlightedIndex = 0;

  @override
  void initState() {
    super.initState();
    _baseId = component.id ?? 'dropdown-edit-field-${_nextDropdownEditFieldId++}';
    _query = _selectedLabel;
  }

  @override
  void didUpdateComponent(DropdownEditField<T> oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (!_isOpen && oldComponent.value != component.value) {
      _query = _selectedLabel;
    }
    if (_highlightedIndex >= _filteredItems.length) {
      _highlightedIndex = 0;
    }
  }

  @override
  Component build(BuildContext context) {
    final items = _filteredItems;
    final menuId = '$_baseId-menu';
    final activeId = items.isEmpty ? null : '$_baseId-option-$_highlightedIndex';
    final hasValue = component.value != null;

    return div(
      classes: [
        'dropdown-edit-field',
        if (component.disabled) 'dropdown-edit-field-disabled',
        if (component.classes != null) component.classes!,
      ].join(' '),
      styles: component.styles,
      [
        div(classes: 'dropdown-edit-field-control', [
          input<String>(
            id: _baseId,
            type: InputType.text,
            value: _query,
            disabled: component.disabled,
            classes: 'dropdown-edit-field-input',
            attributes: {
              'role': 'combobox',
              'autocomplete': 'off',
              'aria-autocomplete': 'list',
              'aria-expanded': _isOpen ? 'true' : 'false',
              'aria-controls': menuId,
              if (activeId != null) 'aria-activedescendant': activeId,
              if (component.placeholder != null) 'placeholder': component.placeholder!,
              if (component.disabled) 'aria-disabled': 'true',
            },
            events: {
              'focus': (_) => _open(),
              'keydown': _handleKeyDown,
            },
            onInput: component.disabled ? null : _handleInput,
          ),
          if (hasValue && !component.disabled)
            button(
              classes: 'dropdown-edit-field-clear',
              type: ButtonType.button,
              attributes: {'aria-label': 'Clear selection'},
              onClick: _clear,
              [.text('×')],
            ),
        ]),
        if (_isOpen && !component.disabled)
          ul(
            id: menuId,
            classes: 'dropdown-edit-field-menu',
            attributes: {'role': 'listbox'},
            items.isEmpty
                ? [
                    li(classes: 'dropdown-edit-field-empty', [.text('No matches')]),
                  ]
                : [
                    for (var index = 0; index < items.length; index++)
                      li([
                        button(
                          id: '$_baseId-option-$index',
                          classes: [
                            'dropdown-edit-field-option',
                            if (index == _highlightedIndex) 'dropdown-edit-field-option-highlighted',
                            if (_isSelected(items[index])) 'dropdown-edit-field-option-selected',
                          ].join(' '),
                          type: ButtonType.button,
                          attributes: {
                            'role': 'option',
                            'aria-selected': _isSelected(items[index]) ? 'true' : 'false',
                          },
                          onClick: () => _select(items[index]),
                          [
                            span([.text(_labelFor(items[index]))]),
                            if (_isSelected(items[index])) span([.text('Selected')]),
                          ],
                        ),
                      ]),
                  ],
          ),
      ],
    );
  }

  List<T> get _filteredItems {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return component.items;
    return component.items.where((item) => _labelFor(item).toLowerCase().contains(query)).toList();
  }

  String get _selectedLabel {
    final selected = component.value;
    if (selected == null) return '';
    return _labelFor(selected);
  }

  String _labelFor(T item) {
    final itemAsString = component.itemAsString;
    if (itemAsString != null) return itemAsString(item);
    if (item is String) return item;
    throw ArgumentError(
      'DropdownEditField<$T> requires itemAsString when items are not strings.',
    );
  }

  bool _isSelected(T item) => component.value == item;

  void _open() {
    if (component.disabled || _isOpen) return;
    setState(() {
      _isOpen = true;
      _highlightedIndex = 0;
    });
  }

  void _handleInput(String value) {
    setState(() {
      _query = value;
      _isOpen = true;
      _highlightedIndex = 0;
    });
  }

  void _handleKeyDown(web.Event event) {
    if (component.disabled) return;

    final keyboardEvent = event as dynamic;
    final items = _filteredItems;
    switch (keyboardEvent.key) {
      case 'ArrowDown':
        keyboardEvent.preventDefault();
        setState(() {
          _isOpen = true;
          if (items.isNotEmpty) {
            _highlightedIndex = (_highlightedIndex + 1) % items.length;
          }
        });
      case 'ArrowUp':
        keyboardEvent.preventDefault();
        setState(() {
          _isOpen = true;
          if (items.isNotEmpty) {
            _highlightedIndex = (_highlightedIndex - 1 + items.length) % items.length;
          }
        });
      case 'Enter':
        if (_isOpen && items.isNotEmpty) {
          keyboardEvent.preventDefault();
          _select(items[_highlightedIndex.clamp(0, items.length - 1).toInt()]);
        }
      case 'Escape':
        keyboardEvent.preventDefault();
        setState(() {
          _isOpen = false;
          _query = _selectedLabel;
        });
      case 'Tab':
        setState(() {
          _isOpen = false;
        });
    }
  }

  void _select(T item) {
    final label = _labelFor(item);
    setState(() {
      _query = label;
      _isOpen = false;
      _highlightedIndex = 0;
    });
    component.onChange(item);
  }

  void _clear() {
    setState(() {
      _query = '';
      _isOpen = false;
      _highlightedIndex = 0;
    });
    component.onChange(null);
  }
}
