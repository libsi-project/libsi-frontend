import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';
import 'package:universal_web/web.dart' as web;

const _defaultMonthNames = [
  'январь',
  'февраль',
  'март',
  'апрель',
  'май',
  'июнь',
  'июль',
  'август',
  'сентябрь',
  'октябрь',
  'ноябрь',
  'декабрь',
];

const _defaultWeekdayLabels = ['П', 'В', 'С', 'Ч', 'П', 'С', 'В'];

enum _DatePickerMode { days, monthYear }

/// Where the calendar popup should anchor horizontally. Callers pin it
/// to the right when the field sits close to the container's right edge
/// so the popup doesn't clip.
enum DatePickerAlign { start, end }

class DatePicker extends StatefulComponent {
  const DatePicker({
    required this.value,
    required this.onChange,
    this.onClear,
    this.onInvalidPick,
    this.firstDate,
    this.lastDate,
    this.initialVisibleMonth,
    this.monthNames = _defaultMonthNames,
    this.weekdayLabels = _defaultWeekdayLabels,
    this.placeholder = 'pick a date',
    this.disabled = false,
    this.align = DatePickerAlign.start,
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : assert(monthNames.length == 12, 'DatePicker monthNames must contain 12 labels.'),
       assert(weekdayLabels.length == 7, 'DatePicker weekdayLabels must contain 7 labels.');

  final DateTime? value;
  final ValueChanged<DateTime> onChange;

  /// Optional handler that unsets the current date. When null the field
  /// hides its inline × button and the popup omits the “Очистить” action.
  final VoidCallback? onClear;

  /// When set, days outside `[firstDate, lastDate]` remain visible and
  /// clickable, calendar navigation is unrestricted, and clicking an
  /// out-of-range day calls this handler instead of [onChange] — so
  /// callers can explain the constraint (e.g. via a toast) without
  /// hiding the invalid day. When null the picker keeps its default
  /// behaviour: nav is capped and invalid days are silently disabled.
  final ValueChanged<DateTime>? onInvalidPick;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialVisibleMonth;
  final List<String> monthNames;
  final List<String> weekdayLabels;
  final String placeholder;
  final bool disabled;
  final DatePickerAlign align;
  final String? id;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.date-picker').styles(
      position: Position.relative(),
      width: 100.percent,
      minWidth: 0.px,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontWeight: FontWeight.w800,
    ),
    css('.date-picker-open').styles(
      zIndex: ZIndex(50),
    ),
    css('.date-picker-field').styles(
      display: Display.flex,
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
      border: NeoTokens.border(color: const Color('var(--date-picker-border-color)')),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      appearance: Appearance.none,
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.center,
      gap: Gap.all(0.65.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.left,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.inputBackground,
      raw: {
        '--date-picker-border-color': 'var(--theme-border)',
        '--date-picker-shadow-color': 'var(--theme-border)',
        'border-width': '2px',
        'box-shadow': '4px 4px 0 0 var(--date-picker-shadow-color)',
        'outline': 'none',
      },
    ),
    css('.date-picker-field:focus-visible, .date-picker-open .date-picker-field').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      raw: {'box-shadow': '3px 3px 0 0 var(--date-picker-shadow-color)'},
    ),
    css('.date-picker-field-value').styles(
      display: Display.flex,
      minWidth: 0.px,
      overflow: Overflow.hidden,
      pointerEvents: PointerEvents.none,
      alignItems: AlignItems.center,
      flex: Flex(grow: 1, shrink: 1),
      raw: {'text-overflow': 'ellipsis'},
    ),
    css('.date-picker-field-placeholder').styles(
      opacity: 0.75,
      color: AppTheme.textSecondary,
    ),
    css('.date-picker-field-icon').styles(
      display: Display.flex,
      pointerEvents: PointerEvents.none,
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
    ),
    css('.date-picker-clear').styles(
      display: Display.inlineFlex,
      width: 22.px,
      height: 22.px,
      padding: Padding.zero,
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.date-picker-clear:hover').styles(
      border: NeoTokens.border(),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      color: AppTheme.textColor,
      backgroundColor: AppTheme.inputBackground,
    ),
    css('.date-picker-calendar').styles(
      display: Display.flex,
      position: Position.absolute(top: 100.percent, left: 0.px),
      zIndex: ZIndex(50),
      width: 15.rem,
      minWidth: 0.px,
      maxWidth: 92.vw,
      padding: Padding.all(0.5.rem),
      margin: Margin.only(top: 0.3.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.4.rem),
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'box-sizing': 'border-box',
        'box-shadow': 'none',
      },
    ),
    css('.date-picker-calendar-end').styles(
      position: Position.absolute(top: 100.percent, right: 0.px),
      raw: {'left': 'auto'},
    ),
    css('.date-picker-footer').styles(
      display: Display.flex,
      padding: Padding.only(top: 0.5.rem),
      border: Border.only(
        top: BorderSide.solid(width: 1.px, color: AppTheme.borderColor),
      ),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
    ),
    css('.date-picker-footer-btn').styles(
      display: Display.inlineFlex,
      padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.25.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.72.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'outline': 'none',
        'box-shadow': '2px 2px 0 0 var(--theme-border)',
      },
    ),
    css('.date-picker-footer-btn:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.date-picker-footer-btn:active').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      raw: {'box-shadow': '1px 1px 0 0 var(--theme-border)'},
    ),
    css('.date-picker-footer-btn-primary').styles(
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.date-picker-footer-btn-primary:hover').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.date-picker-header').styles(
      display: Display.flex,
      minWidth: 0.px,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.35.rem),
    ),
    css('.date-picker-nav-button').styles(
      display: Display.inlineFlex,
      width: 1.5.rem,
      height: 1.5.rem,
      padding: Padding.zero,
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w900,
      backgroundColor: Colors.transparent,
      raw: {'flex': '0 0 auto', 'outline': 'none'},
    ),
    css('.date-picker-nav-button:hover').styles(
      border: NeoTokens.border(),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      color: AppTheme.textColor,
      backgroundColor: AppTheme.inputBackground,
    ),
    css('.date-picker-title-button').styles(
      display: Display.inlineFlex,
      minWidth: 0.px,
      padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.25.rem),
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(0.3.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.8.rem,
      fontWeight: FontWeight.w900,
      backgroundColor: AppTheme.inputBackground,
      raw: {
        'flex': '1 1 0',
        'outline': 'none',
        'line-height': '1.2',
        'overflow-wrap': 'anywhere',
      },
    ),
    css('.date-picker-title-button:hover, .date-picker-title-button:focus-visible').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      backgroundColor: AppTheme.accentColor,
    ),
    css('.date-picker-body').styles(
      display: Display.grid,
      minWidth: 0.px,
      overflow: Overflow.hidden,
    ),
    css('.date-picker-panel').styles(
      minWidth: 0.px,
      raw: {
        'grid-area': '1 / 1',
        'opacity': '1',
        'transform': 'translateY(0)',
        'transition': 'opacity ${NeoTokens.motionSlowMs}ms ease, transform ${NeoTokens.motionSlowMs}ms ease',
      },
    ),
    css('.date-picker-panel-hidden').styles(
      overflow: Overflow.hidden,
      raw: {
        'opacity': '0',
        'transform': 'translateY(8px)',
        'pointer-events': 'none',
      },
    ),
    css('.date-picker-weekdays, .date-picker-days').styles(
      display: Display.grid,
      gap: Gap.all(0.15.rem),
      raw: {'grid-template-columns': 'repeat(7, minmax(0, 1fr))'},
    ),
    css('.date-picker-weekday').styles(
      padding: Padding.symmetric(vertical: 0.15.rem),
      color: AppTheme.textSecondary,
      textAlign: TextAlign.center,
      fontSize: 0.7.rem,
      raw: {'text-transform': 'uppercase'},
    ),
    css('.date-picker-day-button').styles(
      display: Display.inlineFlex,
      width: 100.percent,
      height: 1.65.rem,
      padding: Padding.zero,
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.8.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.date-picker-day-button:hover').styles(
      border: NeoTokens.border(),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      backgroundColor: AppTheme.inputBackground,
    ),
    css('.date-picker-day-outside').styles(
      opacity: 0.35,
    ),
    css('.date-picker-day-today').styles(
      position: Position.relative(),
    ),
    css('.date-picker-day-today::after').styles(
      display: Display.block,
      position: Position.absolute(bottom: 2.px, left: 50.percent),
      width: 4.px,
      height: 4.px,
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      backgroundColor: AppTheme.accentColor,
      raw: {
        'content': "''",
        'transform': 'translateX(-50%)',
      },
    ),
    css('.date-picker-day-selected.date-picker-day-today::after').styles(
      backgroundColor: AppTheme.onAccentColor,
    ),
    css('.date-picker-day-selected').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      color: AppTheme.onAccentColor,
      backgroundColor: AppTheme.accentColor,
    ),
    // Soft-disabled: day stays clickable so we can surface the
    // constraint via [onInvalidPick], but visually communicates the
    // "no-go" state.
    css('.date-picker-day-invalid').styles(
      opacity: 0.4,
      cursor: Cursor.notAllowed,
      color: AppTheme.textSecondary,
      raw: {'text-decoration': 'line-through'},
    ),
    css('.date-picker-day-invalid:hover').styles(
      border: NeoTokens.border(color: AppTheme.errorColor),
      shadow: BoxShadow.none,
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.date-picker-month-year').styles(
      display: Display.grid,
      height: 100.percent,
      minHeight: 19.rem,
      gap: Gap.all(0.5.rem),
      raw: {'grid-template-columns': 'minmax(0, 1fr) minmax(0, 1fr)'},
    ),
    css('.date-picker-wheel').styles(
      display: Display.flex,
      maxHeight: 19.rem,
      padding: Padding.only(right: 0.15.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.2.rem),
      raw: {'overflow-y': 'auto'},
    ),
    css('.date-picker-wheel-option').styles(
      display: Display.inlineFlex,
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.3.rem),
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.82.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: Colors.transparent,
    ),
    css('.date-picker-wheel-option:hover').styles(
      border: NeoTokens.border(),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      backgroundColor: AppTheme.inputBackground,
    ),
    css('.date-picker-wheel-selected').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.date-picker-disabled').styles(
      opacity: 0.5,
    ),
    css('.date-picker-disabled .date-picker-field').styles(
      cursor: Cursor.notAllowed,
    ),
    css('.date-picker-disabled button, .date-picker-button-disabled').styles(
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _visibleMonth;
  _DatePickerMode _mode = _DatePickerMode.days;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _visibleMonth = _monthStart(component.value ?? component.initialVisibleMonth ?? DateTime.now());
  }

  @override
  void didUpdateComponent(DatePicker oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.value != component.value && component.value != null) {
      _visibleMonth = _monthStart(component.value!);
    }
  }

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final formatted = _formattedValue;
    final hasValue = formatted != null;
    final showClearInField = hasValue && component.onClear != null && !component.disabled;
    final calendarId = '${component.id ?? 'date-picker'}-calendar';

    return div(
      id: component.id,
      classes: [
        'date-picker',
        if (_isOpen) 'date-picker-open',
        if (component.disabled) 'date-picker-disabled',
        if (component.classes != null) component.classes!,
      ].join(' '),
      styles: component.styles,
      events: {
        'focusout': _handleFocusOut,
        'keydown': _handleKeyDown,
      },
      [
        button(
          classes: 'date-picker-field',
          type: ButtonType.button,
          disabled: component.disabled,
          attributes: {
            'role': 'combobox',
            'aria-haspopup': 'dialog',
            'aria-expanded': _isOpen ? 'true' : 'false',
            'aria-label': component.placeholder,
            if (_isOpen) 'aria-controls': calendarId,
            if (component.disabled) 'aria-disabled': 'true',
          },
          onClick: component.disabled ? null : _toggle,
          [
            span(classes: 'date-picker-field-icon', [
              const AppIcon(
                IconPaths.calendar,
                width: 18,
                height: 18,
                strokeColor: AppTheme.textSecondary,
              ),
            ]),
            span(
              classes: [
                'date-picker-field-value',
                if (!hasValue) 'date-picker-field-placeholder',
              ].join(' '),
              [
                .text(hasValue ? formatted : component.placeholder),
              ],
            ),
            if (showClearInField)
              span(
                classes: 'date-picker-clear',
                attributes: {
                  'role': 'button',
                  'tabindex': '0',
                  'aria-label': l10n.datePickerClearField,
                },
                events: {
                  'click': _handleClearFieldClick,
                  'keydown': _handleClearFieldKey,
                },
                [
                  const AppIcon(
                    IconPaths.close,
                    width: 14,
                    height: 14,
                    strokeWidth: '3',
                    strokeColor: AppTheme.textSecondary,
                  ),
                ],
              ),
          ],
        ),
        if (_isOpen && !component.disabled)
          div(
            id: calendarId,
            classes: [
              'date-picker-calendar',
              if (component.align == DatePickerAlign.end) 'date-picker-calendar-end',
            ].join(' '),
            attributes: {'role': 'dialog'},
            [
              _header(),
              div(classes: 'date-picker-body', [
                div(
                  classes: [
                    'date-picker-panel',
                    if (_mode != _DatePickerMode.days) 'date-picker-panel-hidden',
                  ].join(' '),
                  attributes: {
                    'aria-hidden': _mode == _DatePickerMode.days ? 'false' : 'true',
                    if (_mode != _DatePickerMode.days) 'inert': '',
                  },
                  [
                    _weekdays(),
                    _days(),
                  ],
                ),
                div(
                  classes: [
                    'date-picker-panel',
                    if (_mode != _DatePickerMode.monthYear) 'date-picker-panel-hidden',
                  ].join(' '),
                  attributes: {
                    'aria-hidden': _mode == _DatePickerMode.monthYear ? 'false' : 'true',
                    if (_mode != _DatePickerMode.monthYear) 'inert': '',
                  },
                  [
                    _monthYearPicker(),
                  ],
                ),
              ]),
              _footer(l10n),
            ],
          ),
      ],
    );
  }

  Component _footer(Translations l10n) {
    // Compare date-only against date-only bounds so "Today" stays
    // enabled when `lastDate` equals today at midnight (raw
    // DateTime.now() would appear to be after that boundary).
    final canGoToday = _isDateEnabled(_dateOnly(DateTime.now()));
    return div(classes: 'date-picker-footer', [
      button(
        classes: [
          'date-picker-footer-btn',
          if (component.onClear == null) 'date-picker-button-disabled',
        ].join(' '),
        type: ButtonType.button,
        disabled: component.onClear == null,
        onClick: component.onClear == null ? null : _handleClearPopup,
        [.text(l10n.datePickerClear)],
      ),
      button(
        classes: [
          'date-picker-footer-btn',
          'date-picker-footer-btn-primary',
          if (!canGoToday) 'date-picker-button-disabled',
        ].join(' '),
        type: ButtonType.button,
        disabled: !canGoToday,
        onClick: canGoToday ? _handleToday : null,
        [.text(l10n.datePickerToday)],
      ),
    ]);
  }

  void _handleClearFieldClick(web.Event event) {
    event.stopPropagation();
    event.preventDefault();
    final handler = component.onClear;
    if (handler == null || component.disabled) return;
    _close();
    handler();
  }

  void _handleClearFieldKey(web.Event event) {
    final key = (event as web.KeyboardEvent).key;
    if (key != 'Enter' && key != ' ') return;
    event.stopPropagation();
    event.preventDefault();
    final handler = component.onClear;
    if (handler == null || component.disabled) return;
    _close();
    handler();
  }

  void _handleClearPopup() {
    final handler = component.onClear;
    if (handler == null) return;
    _close();
    handler();
  }

  void _handleToday() {
    final today = _dateOnly(DateTime.now());
    setState(() {
      _visibleMonth = _monthStart(today);
      _isOpen = false;
      _mode = _DatePickerMode.days;
    });
    component.onChange(today);
  }

  Component _header() {
    final isMonthYearMode = _mode == _DatePickerMode.monthYear;
    final l10n = context.l10n;
    return div(classes: 'date-picker-header', [
      button(
        classes: 'date-picker-nav-button',
        type: ButtonType.button,
        disabled: component.disabled || !_canNavigate(-1),
        attributes: {
          'aria-label': isMonthYearMode ? l10n.datePickerPreviousYear : l10n.datePickerPreviousMonth,
        },
        onClick: component.disabled || !_canNavigate(-1) ? null : () => _navigate(-1),
        [.text('<')],
      ),
      button(
        classes: 'date-picker-title-button',
        type: ButtonType.button,
        disabled: component.disabled,
        attributes: {'aria-expanded': isMonthYearMode ? 'true' : 'false'},
        onClick: component.disabled
            ? null
            : () {
                setState(() {
                  _mode = isMonthYearMode ? _DatePickerMode.days : _DatePickerMode.monthYear;
                });
              },
        [
          .text(
            '${component.monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
          ),
        ],
      ),
      button(
        classes: 'date-picker-nav-button',
        type: ButtonType.button,
        disabled: component.disabled || !_canNavigate(1),
        attributes: {
          'aria-label': isMonthYearMode ? l10n.datePickerNextYear : l10n.datePickerNextMonth,
        },
        onClick: component.disabled || !_canNavigate(1) ? null : () => _navigate(1),
        [.text('>')],
      ),
    ]);
  }

  Component _weekdays() {
    return div(classes: 'date-picker-weekdays', [
      for (final label in component.weekdayLabels) div(classes: 'date-picker-weekday', [.text(label)]),
    ]);
  }

  Component _days() {
    final firstDayOfMonth = _monthStart(_visibleMonth);
    final gridStart = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - DateTime.monday));
    final today = DateTime.now();

    return div(classes: 'date-picker-days', [
      for (var offset = 0; offset < 42; offset++) _dayButton(_dateOnly(gridStart.add(Duration(days: offset))), today),
    ]);
  }

  Component _dayButton(DateTime date, DateTime today) {
    final selected = component.value != null && _isSameDay(component.value!, date);
    final isToday = _isSameDay(today, date);
    final outside = !_isSameMonth(date, _visibleMonth);
    final inRange = _isDateEnabled(date);
    final invalidHandler = component.onInvalidPick;
    // When invalidHandler is set we let the user click out-of-range
    // days so we can surface *why* the click is rejected. Without it
    // we fall back to a hard `disabled` state.
    final softInvalid = !inRange && invalidHandler != null;
    final hardDisabled = component.disabled || (!inRange && invalidHandler == null);

    void handleClick() {
      if (component.disabled) return;
      if (!inRange) {
        invalidHandler?.call(date);
        return;
      }
      setState(() {
        _visibleMonth = _monthStart(date);
        _isOpen = false;
        _mode = _DatePickerMode.days;
      });
      component.onChange(date);
    }

    return button(
      classes: [
        'date-picker-day-button',
        if (outside) 'date-picker-day-outside',
        if (isToday) 'date-picker-day-today',
        if (selected) 'date-picker-day-selected',
        if (softInvalid) 'date-picker-day-invalid',
        if (hardDisabled) 'date-picker-button-disabled',
      ].join(' '),
      type: ButtonType.button,
      disabled: hardDisabled,
      attributes: {
        'aria-label': '${date.day}.${date.month}.${date.year}',
        if (selected) 'aria-current': 'date',
        if (softInvalid) 'aria-disabled': 'true',
      },
      onClick: hardDisabled ? null : handleClick,
      [.text(date.day.toString())],
    );
  }

  Component _monthYearPicker() {
    return div(classes: 'date-picker-month-year', [
      div(classes: 'date-picker-wheel', [
        for (final monthDate in _visibleMonths()) _monthOption(monthDate),
      ]),
      div(classes: 'date-picker-wheel', [
        for (final year in _visibleYears()) _yearOption(year),
      ]),
    ]);
  }

  Component _monthOption(DateTime monthDate) {
    final selected = monthDate.month == _visibleMonth.month;
    final softInvalid = component.onInvalidPick != null;
    final enabled = !component.disabled && (softInvalid || _isMonthEnabled(_visibleMonth.year, monthDate.month));

    return button(
      classes: [
        'date-picker-wheel-option',
        if (selected) 'date-picker-wheel-selected',
        if (!enabled) 'date-picker-button-disabled',
      ].join(' '),
      type: ButtonType.button,
      disabled: !enabled,
      onClick: enabled
          ? () {
              setState(() {
                _visibleMonth = DateTime(_visibleMonth.year, monthDate.month);
              });
            }
          : null,
      [.text(component.monthNames[monthDate.month - 1])],
    );
  }

  Component _yearOption(int year) {
    final selected = year == _visibleMonth.year;
    final softInvalid = component.onInvalidPick != null;
    final enabled = !component.disabled && (softInvalid || _isYearEnabled(year));

    return button(
      classes: [
        'date-picker-wheel-option',
        if (selected) 'date-picker-wheel-selected',
        if (!enabled) 'date-picker-button-disabled',
      ].join(' '),
      type: ButtonType.button,
      disabled: !enabled,
      onClick: enabled
          ? () {
              setState(() {
                _visibleMonth = softInvalid
                    ? DateTime(year, _visibleMonth.month)
                    : _nearestEnabledMonth(DateTime(year, _visibleMonth.month));
              });
            }
          : null,
      [.text(year.toString())],
    );
  }

  List<DateTime> _visibleMonths() {
    // Rotate so the current month sits at the top of the wheel — the
    // user asked for "start from our month" instead of always leading
    // with January.
    final currentMonth = DateTime.now().month;
    return [
      for (var offset = 0; offset < 12; offset++) DateTime(2000, ((currentMonth - 1 + offset) % 12) + 1),
    ];
  }

  List<int> _visibleYears() {
    // Newest year first so the current year lands at the top of the
    // wheel and past years scroll below.
    return [
      for (var year = _lastPickerYear; year >= _firstPickerYear; year--) year,
    ];
  }

  bool _canNavigate(int direction) {
    // When the picker allows soft-invalid picks we let the user roam
    // freely — capping nav here would hide the very months they need
    // to see (e.g. paging past `firstDate` to inspect earlier dates).
    if (component.onInvalidPick != null) return true;
    final next = _mode == _DatePickerMode.days
        ? DateTime(_visibleMonth.year, _visibleMonth.month + direction)
        : DateTime(_visibleMonth.year + direction, _visibleMonth.month);
    if (_mode == _DatePickerMode.days) return _isMonthEnabled(next.year, next.month);
    return next.year >= _firstPickerYear && next.year <= _lastPickerYear && _isYearEnabled(next.year);
  }

  void _navigate(int direction) {
    setState(() {
      final next = _mode == _DatePickerMode.days
          ? DateTime(_visibleMonth.year, _visibleMonth.month + direction)
          : DateTime(_visibleMonth.year + direction, _visibleMonth.month);
      _visibleMonth = component.onInvalidPick != null ? next : _nearestEnabledMonth(next);
    });
  }

  // Ignore anything before 2001 — SIGame packages don't predate the
  // modern tournament era and the user asked to hide those years.
  static const int _earliestAllowedYear = 2001;

  int get _firstPickerYear {
    final requested = component.firstDate?.year ?? _earliestAllowedYear;
    return requested < _earliestAllowedYear ? _earliestAllowedYear : requested;
  }

  int get _lastPickerYear {
    final now = DateTime.now().year;
    final requested = component.lastDate?.year ?? now;
    return requested < now ? now : requested;
  }

  bool _isDateEnabled(DateTime date) {
    final firstDate = component.firstDate == null ? null : _dateOnly(component.firstDate!);
    final lastDate = component.lastDate == null ? null : _dateOnly(component.lastDate!);
    if (firstDate != null && date.isBefore(firstDate)) return false;
    if (lastDate != null && date.isAfter(lastDate)) return false;
    return true;
  }

  bool _isMonthEnabled(int year, int month) {
    final firstDay = DateTime(year, month);
    final lastDay = DateTime(year, month + 1, 0);
    return _isDateEnabled(firstDay) || _isDateEnabled(lastDay) || _rangeContainsMonth(year, month);
  }

  bool _isYearEnabled(int year) {
    for (var month = DateTime.january; month <= DateTime.december; month++) {
      if (_isMonthEnabled(year, month)) return true;
    }
    return false;
  }

  bool _rangeContainsMonth(int year, int month) {
    final firstDate = component.firstDate == null ? null : _dateOnly(component.firstDate!);
    final lastDate = component.lastDate == null ? null : _dateOnly(component.lastDate!);
    if (firstDate == null || lastDate == null) return false;
    final monthStart = DateTime(year, month);
    final monthEnd = DateTime(year, month + 1, 0);
    return !firstDate.isAfter(monthEnd) && !lastDate.isBefore(monthStart);
  }

  DateTime _nearestEnabledMonth(DateTime month) {
    final normalized = _monthStart(month);
    if (_isMonthEnabled(normalized.year, normalized.month)) return normalized;

    final firstDate = component.firstDate == null ? null : _monthStart(component.firstDate!);
    final lastDate = component.lastDate == null ? null : _monthStart(component.lastDate!);
    if (firstDate != null && normalized.isBefore(firstDate)) return firstDate;
    if (lastDate != null && normalized.isAfter(lastDate)) return lastDate;
    return normalized;
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

  String? get _formattedValue {
    final value = component.value;
    if (value == null) return null;
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day.$month.${value.year}';
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (component.disabled || _isOpen) return;
    setState(() {
      _isOpen = true;
      _mode = _DatePickerMode.days;
      if (component.value != null) {
        _visibleMonth = _monthStart(component.value!);
      }
    });
  }

  void _close() {
    if (!_isOpen) return;
    setState(() {
      _isOpen = false;
      _mode = _DatePickerMode.days;
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
    switch (keyboardEvent.key) {
      case 'Escape':
        if (_isOpen) {
          keyboardEvent.preventDefault();
          _close();
        }
      case 'ArrowDown':
        if (!_isOpen) {
          keyboardEvent.preventDefault();
          _open();
        }
    }
  }
}
