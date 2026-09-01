import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';
import 'package:universal_web/web.dart' as web;

class DropdownEditField<T> extends StatefulComponent {
  DropdownEditField({
    required this.items,
    required this.value,
    required this.onChange,
    required this.id,
    this.itemAsString,
    this.placeholder,
    this.disabled = false,
    this.classes,
    this.styles,
    super.key,
  }) : assert(
         itemAsString != null || T == String,
         'DropdownEditField<$T> requires itemAsString when items are not strings.',
       );

  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChange;
  final String Function(T)? itemAsString;
  final String? placeholder;
  final bool disabled;
  final String id;
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
    css('.dropdown-edit-field-trigger').styles(
      display: Display.flex,
      width: 100.percent,
      minHeight: 2.5.rem,
      padding: Padding.only(left: 0.625.rem, right: 0.5.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      appearance: Appearance.none,
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.375.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.left,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w700,
      whiteSpace: WhiteSpace.noWrap,
      backgroundColor: AppTheme.inputBackground,
      raw: {'outline': 'none'},
    ),
    css('.dropdown-edit-field-trigger:focus-visible').styles(
      outline: Outline(
        color: AppTheme.primaryColor,
        style: OutlineStyle.solid,
        width: OutlineWidth(2.px),
        offset: 2.px,
      ),
    ),
    css('.dropdown-edit-field-value').styles(
      display: Display.flex,
      minWidth: 0.px,
      overflow: Overflow.hidden,
      pointerEvents: PointerEvents.none,
      alignItems: AlignItems.center,
      flex: Flex(grow: 1, shrink: 1),
      raw: {'text-overflow': 'ellipsis'},
    ),
    css('.dropdown-edit-field-placeholder').styles(
      color: AppTheme.textSecondary,
    ),
    css('.dropdown-edit-field-chevron').styles(
      pointerEvents: PointerEvents.none,
      transition: Transition('transform', duration: NeoTokens.motionFastMs.ms),
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
    ),
    css('.dropdown-edit-field-open .dropdown-edit-field-chevron').styles(
      transform: Transform.rotate(180.deg),
    ),
    css('.dropdown-edit-field-menu').styles(
      display: Display.flex,
      position: Position.absolute(top: 100.percent, left: 0.px, right: 0.px),
      zIndex: ZIndex(50),
      minWidth: 9.rem,
      maxHeight: 16.rem,
      padding: Padding.all(0.25.rem),
      margin: Margin.only(top: 0.25.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowMd),
      flexDirection: FlexDirection.column,
      color: AppTheme.textColor,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'overflow-x': 'hidden', 'overflow-y': 'auto', 'list-style': 'none'},
    ),
    css('.dropdown-edit-field-option').styles(
      display: Display.flex,
      position: Position.relative(),
      width: 100.percent,
      padding: Padding.only(left: 0.375.rem, right: 2.rem, top: 0.25.rem, bottom: 0.25.rem),
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      appearance: Appearance.none,
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.center,
      gap: Gap.all(0.375.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.left,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.dropdown-edit-field-option:hover, .dropdown-edit-field-option-highlighted').styles(
      color: AppTheme.textColor,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.dropdown-edit-field-option-check').styles(
      display: Display.flex,
      position: Position.absolute(top: 0.px, right: 0.5.rem, bottom: 0.px),
      width: 1.rem,
      pointerEvents: PointerEvents.none,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
    ),
    css('.dropdown-edit-field-empty').styles(
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.7.rem),
      color: AppTheme.textSecondary,
      fontSize: 0.875.rem,
    ),
    css('.dropdown-edit-field-disabled').styles(
      opacity: 0.5,
    ),
    css('.dropdown-edit-field-disabled .dropdown-edit-field-trigger').styles(
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  State<DropdownEditField<T>> createState() => _DropdownEditFieldState<T>();
}

class _DropdownEditFieldState<T> extends State<DropdownEditField<T>> {
  bool _isOpen = false;
  int _highlightedIndex = 0;

  String get _baseId => component.id;

  @override
  void didUpdateComponent(DropdownEditField<T> oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (_highlightedIndex >= component.items.length) {
      _highlightedIndex = 0;
    }
  }

  @override
  Component build(BuildContext context) {
    final items = component.items;
    final menuId = '$_baseId-menu';
    final activeId = items.isEmpty ? null : '$_baseId-option-$_highlightedIndex';
    final selectedLabel = _selectedLabel;
    final hasValue = selectedLabel.isNotEmpty;

    return div(
      classes: [
        'dropdown-edit-field',
        if (_isOpen) 'dropdown-edit-field-open',
        if (component.disabled) 'dropdown-edit-field-disabled',
        if (component.classes != null) component.classes!,
      ].join(' '),
      styles: component.styles,
      events: {
        'focusout': _handleFocusOut,
      },
      [
        button(
          id: _baseId,
          type: ButtonType.button,
          disabled: component.disabled,
          classes: 'dropdown-edit-field-trigger',
          attributes: {
            'role': 'combobox',
            'aria-expanded': _isOpen ? 'true' : 'false',
            'aria-autocomplete': 'none',
            'aria-haspopup': 'listbox',
            if (_isOpen && !component.disabled) 'aria-controls': menuId,
            if (_isOpen && !component.disabled && activeId != null) 'aria-activedescendant': activeId,
            if (component.disabled) 'aria-disabled': 'true',
          },
          events: {
            'keydown': _handleKeyDown,
          },
          onClick: component.disabled ? null : _toggle,
          [
            span(
              classes: [
                'dropdown-edit-field-value',
                if (!hasValue) 'dropdown-edit-field-placeholder',
              ].join(' '),
              [
                .text(hasValue ? selectedLabel : (component.placeholder ?? '')),
              ],
            ),
            span(classes: 'dropdown-edit-field-chevron', [
              const AppIcon(
                IconPaths.chevronDown,
                width: 16,
                height: 16,
                strokeColor: AppTheme.textSecondary,
              ),
            ]),
          ],
        ),
        if (_isOpen && !component.disabled)
          ul(
            id: menuId,
            classes: 'dropdown-edit-field-menu',
            attributes: {'role': 'listbox'},
            items.isEmpty
                ? [
                    li(classes: 'dropdown-edit-field-empty', [.text('No items')]),
                  ]
                : [
                    for (var index = 0; index < items.length; index++)
                      li([
                        button(
                          id: '$_baseId-option-$index',
                          classes: [
                            'dropdown-edit-field-option',
                            if (index == _highlightedIndex) 'dropdown-edit-field-option-highlighted',
                          ].join(' '),
                          type: ButtonType.button,
                          attributes: {
                            'role': 'option',
                            'aria-selected': _isSelected(items[index]) ? 'true' : 'false',
                          },
                          onClick: () => _select(items[index]),
                          [
                            span([.text(_labelFor(items[index]))]),
                            if (_isSelected(items[index]))
                              span(classes: 'dropdown-edit-field-option-check', [
                                const AppIcon(
                                  IconPaths.check,
                                  width: 16,
                                  height: 16,
                                ),
                              ]),
                          ],
                        ),
                      ]),
                  ],
          ),
      ],
    );
  }

  String get _selectedLabel {
    final selected = component.value;
    if (selected == null) return '';
    return _labelFor(selected);
  }

  String _labelFor(T item) {
    final itemAsString = component.itemAsString;
    if (itemAsString != null) return itemAsString(item);
    return item as String;
  }

  bool _isSelected(T item) => component.value == item;

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (component.disabled || _isOpen) return;
    final selectedIndex = component.items.indexWhere(_isSelected);
    setState(() {
      _isOpen = true;
      _highlightedIndex = selectedIndex >= 0 ? selectedIndex : 0;
    });
  }

  void _close() {
    if (!_isOpen) return;
    setState(() {
      _isOpen = false;
    });
  }

  void _handleFocusOut(web.Event event) {
    if (!_isOpen || component.disabled) return;

    final focusEvent = event as web.FocusEvent;
    final relatedTarget = focusEvent.relatedTarget;
    final currentTarget = focusEvent.currentTarget;
    if (relatedTarget != null && currentTarget != null) {
      final relatedNode = relatedTarget as web.Node;
      final currentNode = currentTarget as web.Node;
      if (currentNode.contains(relatedNode)) {
        return;
      }
    }

    _close();
  }

  void _handleKeyDown(web.Event event) {
    if (component.disabled) return;

    final keyboardEvent = event as web.KeyboardEvent;
    final items = component.items;
    switch (keyboardEvent.key) {
      case 'ArrowDown':
        keyboardEvent.preventDefault();
        if (!_isOpen) {
          _open();
        } else if (items.isNotEmpty) {
          setState(() {
            _highlightedIndex = (_highlightedIndex + 1) % items.length;
          });
        }
      case 'ArrowUp':
        keyboardEvent.preventDefault();
        if (!_isOpen) {
          _open();
        } else if (items.isNotEmpty) {
          setState(() {
            _highlightedIndex = (_highlightedIndex - 1 + items.length) % items.length;
          });
        }
      case 'Home':
        if (_isOpen && items.isNotEmpty) {
          keyboardEvent.preventDefault();
          setState(() => _highlightedIndex = 0);
        }
      case 'End':
        if (_isOpen && items.isNotEmpty) {
          keyboardEvent.preventDefault();
          setState(() => _highlightedIndex = items.length - 1);
        }
      case 'Enter':
      case ' ':
        if (_isOpen && items.isNotEmpty) {
          keyboardEvent.preventDefault();
          _select(items[_highlightedIndex.clamp(0, items.length - 1).toInt()]);
        }
      case 'Escape':
        if (_isOpen) {
          keyboardEvent.preventDefault();
          _close();
        }
      case 'Tab':
        _close();
    }
  }

  void _select(T item) {
    setState(() {
      _isOpen = false;
      _highlightedIndex = 0;
    });
    component.onChange(item);
  }
}
