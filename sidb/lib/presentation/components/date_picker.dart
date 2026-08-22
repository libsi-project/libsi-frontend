import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

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

class DatePicker extends StatefulComponent {
  const DatePicker({
    required this.value,
    required this.onChange,
    this.firstDate,
    this.lastDate,
    this.initialVisibleMonth,
    this.monthNames = _defaultMonthNames,
    this.weekdayLabels = _defaultWeekdayLabels,
    this.disabled = false,
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : assert(monthNames.length == 12, 'DatePicker monthNames must contain 12 labels.'),
       assert(weekdayLabels.length == 7, 'DatePicker weekdayLabels must contain 7 labels.');

  final DateTime? value;
  final ValueChanged<DateTime> onChange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialVisibleMonth;
  final List<String> monthNames;
  final List<String> weekdayLabels;
  final bool disabled;
  final String? id;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.date-picker').styles(
      display: Display.flex,
      width: 100.percent,
      minWidth: 0.px,
      maxWidth: 20.rem,
      padding: Padding.all(0.75.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusLg),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowMd),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-sizing': 'border-box'},
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
      width: 2.rem,
      height: 2.rem,
      padding: Padding.zero,
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.25.rem,
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
      padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.4.rem),
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(0.35.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.9.rem,
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
      gap: Gap.all(0.25.rem),
      raw: {'grid-template-columns': 'repeat(7, minmax(0, 1fr))'},
    ),
    css('.date-picker-weekday').styles(
      padding: Padding.symmetric(vertical: 0.25.rem),
      color: AppTheme.textSecondary,
      textAlign: TextAlign.center,
      fontSize: 0.85.rem,
      raw: {'text-transform': 'uppercase'},
    ),
    css('.date-picker-day-button').styles(
      display: Display.inlineFlex,
      width: 100.percent,
      height: 2.25.rem,
      padding: Padding.zero,
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
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
      border: NeoTokens.border(color: AppTheme.accentColor),
    ),
    css('.date-picker-day-selected').styles(
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      color: AppTheme.onAccentColor,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.date-picker-month-year').styles(
      display: Display.grid,
      height: 100.percent,
      minHeight: 14.5.rem,
      gap: Gap.all(0.75.rem),
      raw: {'grid-template-columns': 'minmax(0, 1fr) minmax(0, 1fr)'},
    ),
    css('.date-picker-wheel').styles(
      display: Display.flex,
      maxHeight: 10.75.rem,
      padding: Padding.only(right: 0.15.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.25.rem),
      raw: {'overflow-y': 'auto'},
    ),
    css('.date-picker-wheel-option').styles(
      display: Display.inlineFlex,
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.45.rem),
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
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
    css('.date-picker-disabled button, .date-picker-button-disabled').styles(
      cursor: Cursor.notAllowed,
    ),
  ];

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _visibleMonth;
  late final int _fallbackCenterYear;
  _DatePickerMode _mode = _DatePickerMode.days;

  @override
  void initState() {
    super.initState();
    _visibleMonth = _monthStart(component.value ?? component.initialVisibleMonth ?? DateTime.now());
    _fallbackCenterYear = _visibleMonth.year;
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
    return div(
      id: component.id,
      classes: [
        'date-picker',
        if (component.disabled) 'date-picker-disabled',
        if (component.classes != null) component.classes!,
      ].join(' '),
      styles: component.styles,
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
      ],
    );
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
            '${component.monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year} ${l10n.datePickerYearSuffix}',
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
    final disabled = component.disabled || !_isDateEnabled(date);

    return button(
      classes: [
        'date-picker-day-button',
        if (outside) 'date-picker-day-outside',
        if (isToday) 'date-picker-day-today',
        if (selected) 'date-picker-day-selected',
        if (disabled) 'date-picker-button-disabled',
      ].join(' '),
      type: ButtonType.button,
      disabled: disabled,
      attributes: {
        'aria-label': '${date.day}.${date.month}.${date.year}',
        if (selected) 'aria-current': 'date',
      },
      onClick: disabled
          ? null
          : () {
              setState(() {
                _visibleMonth = _monthStart(date);
              });
              component.onChange(date);
            },
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
    final enabled = !component.disabled && _isMonthEnabled(_visibleMonth.year, monthDate.month);

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
    final enabled = !component.disabled && _isYearEnabled(year);

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
                _visibleMonth = _nearestEnabledMonth(DateTime(year, _visibleMonth.month));
              });
            }
          : null,
      [.text(year.toString())],
    );
  }

  List<DateTime> _visibleMonths() {
    return [
      for (var month = DateTime.january; month <= DateTime.december; month++) DateTime(2000, month),
    ];
  }

  List<int> _visibleYears() {
    return [
      for (var year = _firstPickerYear; year <= _lastPickerYear; year++) year,
    ];
  }

  bool _canNavigate(int direction) {
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
      _visibleMonth = _nearestEnabledMonth(next);
    });
  }

  int get _firstPickerYear => component.firstDate?.year ?? _fallbackCenterYear - 100;

  int get _lastPickerYear => component.lastDate?.year ?? _fallbackCenterYear + 100;

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
}
