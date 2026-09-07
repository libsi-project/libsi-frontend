import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/components/checkbox.dart';
import 'package:sidb/presentation/components/date_picker.dart';
import 'package:sidb/presentation/components/dropdown_edit_field.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_badge.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/neo_toast.dart';
import 'package:sidb/presentation/features/pack/model/game_type/game_type.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';
import 'package:sidb/presentation/features/search/model/search_query.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';
import 'package:universal_web/web.dart' as web;

/// Renders the filter controls for the current entity. Every change is
/// bubbled up as a new [SearchQuery] via [onChange]; the parent owns
/// the query state and mirrors it to the URL. Individual filter
/// groups keep their own local expand/collapse state.
class SearchFilters extends StatelessComponent {
  const SearchFilters({
    required this.query,
    required this.onChange,
    super.key,
  });

  final SearchQuery query;
  final ValueChanged<SearchQuery> onChange;

  @css
  static List<StyleRule> get styles => [
    css('.sf-group').styles(
      display: Display.flex,
      padding: Padding.zero,
      border: Border.none,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.55.rem),
    ),
    css('.sf-summary').styles(
      display: Display.flex,
      width: 100.percent,
      padding: Padding.only(bottom: 0.2.rem),
      border: Border.none,
      appearance: Appearance.none,
      cursor: Cursor.pointer,
      alignItems: AlignItems.center,
      gap: Gap.all(0.4.rem),
      color: AppTheme.textSecondary,
      textAlign: TextAlign.left,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 11.px,
      fontWeight: FontWeight.w800,
      textTransform: TextTransform.upperCase,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none', 'letter-spacing': '0.06em'},
    ),
    css('.sf-summary:hover, .sf-summary:focus-visible').styles(
      color: AppTheme.textColor,
    ),
    css('.sf-summary:focus-visible').styles(
      raw: {'outline': '2px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.sf-summary-title').styles(
      raw: {'white-space': 'nowrap'},
    ),
    css('.sf-summary-count').styles(
      display: Display.inlineFlex,
      height: 18.px,
      minWidth: 18.px,
      padding: Padding.symmetric(horizontal: 5.px),
      border: NeoTokens.border(width: 1),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.onPrimaryColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 10.px,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.primaryColor,
      raw: {'letter-spacing': '0'},
    ),
    css('.sf-summary-divider').styles(
      height: 2.px,
      flex: Flex(grow: 1),
      backgroundColor: AppTheme.borderColor,
      raw: {'opacity': '0.35'},
    ),
    css('.sf-summary-chevron').styles(
      display: Display.inlineFlex,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.rotate(0.deg),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
    ),
    css('.sf-group-collapsed .sf-summary-chevron').styles(
      transform: Transform.rotate((-90).deg),
    ),
    css('.sf-body').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.55.rem),
    ),
    css('.sf-group-collapsed .sf-body').styles(display: Display.none),
    css('.sf-badges').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 0.4.rem, column: 0.4.rem),
    ),
    css('.sf-badge-btn').styles(
      padding: Padding.zero,
      border: Border.none,
      appearance: Appearance.none,
      cursor: Cursor.pointer,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.sf-badge-btn:focus-visible .neo-badge').styles(
      outline: Outline(
        color: AppTheme.primaryColor,
        style: OutlineStyle.solid,
        width: OutlineWidth(2.px),
        offset: 2.px,
      ),
    ),
    css('.sf-badge-btn .neo-badge').styles(
      padding: Padding.symmetric(horizontal: 10.px, vertical: 5.px),
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      fontSize: 12.px,
    ),
    css('.sf-badge-btn:hover .neo-badge').styles(
      transform: Transform.translate(x: (-1).px, y: (-1).px),
    ),
    css('.sf-date-stack').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.5.rem),
    ),
    css('.sf-number-row').styles(
      display: Display.grid,
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(.fr(1)), GridTrack(.fr(1))]),
      ),
      gap: Gap(row: 0.5.rem, column: 0.5.rem),
    ),
    css('.sf-field-label').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.3.rem),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 11.px,
      fontWeight: FontWeight.w700,
      textTransform: TextTransform.upperCase,
      raw: {'letter-spacing': '0.04em'},
    ),
    css('.sf-field-label .neo-input, .sf-field-label .date-picker-field').styles(
      padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.45.rem),
      fontSize: 0.9.rem,
    ),
    css('.sf-venue').styles(
      display: Display.grid,
      gridTemplate: GridTemplate(
        columns: GridTracks(
          [
            GridTrack.repeat(const TrackRepeat(3), [GridTrack(.fr(1))]),
          ],
        ),
      ),
      gap: Gap.all(0.35.rem),
    ),
    css('.sf-venue-option').styles(
      display: Display.inlineFlex,
      padding: Padding.symmetric(horizontal: 0.3.rem, vertical: 0.5.rem),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.82.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'outline': 'none',
        'box-shadow': '2px 2px 0 0 var(--theme-border)',
      },
    ),
    css('.sf-venue-option:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.sf-venue-option-active').styles(
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.sf-venue-option-active:hover').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.sf-venue-option:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.sf-scope').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.4.rem),
    ),
    css('.sf-scope .neo-checkbox').styles(
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w700,
      gap: Gap.all(0.55.rem),
    ),
    css('.sf-scope .neo-checkbox-box').styles(
      width: 1.15.rem,
      height: 1.15.rem,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return Component.fragment([
      if (query.entity != SearchEntity.authors)
        _CollapsibleGroup(
          key: const ValueKey('sf-audience'),
          title: l10n.searchFilterAudience,
          activeCount: query.audiences.length,
          body: _audienceBody(l10n),
        ),
      if (query.entity != SearchEntity.authors)
        _CollapsibleGroup(
          key: const ValueKey('sf-playdate'),
          title: l10n.searchFilterPlayDateRange,
          activeCount: (query.playFrom != null ? 1 : 0) + (query.playTo != null ? 1 : 0),
          body: _playDateBody(context, l10n),
        ),
      if (query.entity != SearchEntity.authors)
        _CollapsibleGroup(
          key: const ValueKey('sf-gametype'),
          title: l10n.searchFilterGameType,
          activeCount: query.gameTypes.length,
          body: _gameTypeBody(l10n),
        ),
      if (query.entity == SearchEntity.tournaments)
        _CollapsibleGroup(
          key: const ValueKey('sf-topics'),
          title: l10n.searchFilterTopicsRange,
          activeCount: (query.topicsMin != null ? 1 : 0) + (query.topicsMax != null ? 1 : 0),
          body: _topicsBody(l10n),
        ),
      if (query.entity == SearchEntity.tournaments)
        _CollapsibleGroup(
          key: const ValueKey('sf-venue'),
          title: l10n.searchFilterVenue,
          activeCount: query.venue == SearchVenue.any ? 0 : 1,
          body: _venueBody(l10n),
        ),
      if (SearchScopeMeta.appliesTo(query.entity))
        _CollapsibleGroup(
          key: const ValueKey('sf-scope'),
          title: l10n.searchFilterScopeLabel,
          activeCount: query.scopes.length,
          body: _scopeBody(l10n),
        ),
      _CollapsibleGroup(
        key: const ValueKey('sf-sort'),
        title: l10n.searchFilterSortLabel,
        activeCount: 0,
        body: _sortBody(l10n),
      ),
    ]);
  }

  Component _scopeBody(Translations l10n) {
    final active = query.effectiveScopes;
    return div(classes: 'sf-scope', [
      for (final scope in SearchScope.values)
        Checkbox(
          checked: active.contains(scope),
          label: .text(scope.label(l10n)),
          onChange: (isOn) {
            final next = {...query.scopes.isEmpty ? active : query.scopes};
            if (isOn) {
              next.add(scope);
            } else {
              next.remove(scope);
            }
            onChange(query.copyWith(scopes: next));
          },
        ),
    ]);
  }

  Component _audienceBody(Translations l10n) {
    return div(classes: 'sf-badges', [
      for (final audience in TargetAudience.values)
        _toggleBadge(
          label: audience.label(l10n),
          selected: query.audiences.contains(audience),
          selectedTone: _audienceTone(audience),
          onToggle: () => onChange(
            query.copyWith(audiences: _toggle(query.audiences, audience)),
          ),
        ),
    ]);
  }

  Component _gameTypeBody(Translations l10n) {
    return div(classes: 'sf-badges', [
      for (final type in GameType.values)
        _toggleBadge(
          label: type.label(l10n),
          selected: query.gameTypes.contains(type),
          selectedTone: NeoBadgeTone.thematic,
          onToggle: () => onChange(
            query.copyWith(gameTypes: _toggle(query.gameTypes, type)),
          ),
        ),
    ]);
  }

  Component _playDateBody(BuildContext context, Translations l10n) {
    return div(classes: 'sf-date-stack', [
      label(classes: 'sf-field-label', [
        span([.text(l10n.searchFilterPlayDateFrom)]),
        DatePicker(
          value: query.playFrom,
          placeholder: l10n.searchFilterPlayDateFrom,
          lastDate: query.playTo,
          onChange: (date) => onChange(query.copyWith(playFrom: date)),
          onClear: query.playFrom == null ? null : () => onChange(query.copyWith(clearPlayFrom: true)),
          onInvalidPick: (_) => ToastScope.of(context).show(l10n.searchFilterPlayDateFromAfterTo),
        ),
      ]),
      label(classes: 'sf-field-label', [
        span([.text(l10n.searchFilterPlayDateTo)]),
        DatePicker(
          value: query.playTo,
          placeholder: l10n.searchFilterPlayDateTo,
          firstDate: query.playFrom,
          onChange: (date) => onChange(query.copyWith(playTo: date)),
          onClear: query.playTo == null ? null : () => onChange(query.copyWith(clearPlayTo: true)),
          onInvalidPick: (_) => ToastScope.of(context).show(l10n.searchFilterPlayDateToBeforeFrom),
        ),
      ]),
    ]);
  }

  Component _topicsBody(Translations l10n) {
    return div(classes: 'sf-number-row', [
      label(classes: 'sf-field-label', [
        span([.text(l10n.searchFilterTopicsMin)]),
        NeoInput(
          type: 'number',
          value: query.topicsMin?.toString(),
          placeholder: '0',
          attributes: const {'inputmode': 'numeric', 'min': '0'},
          onInput: (event) {
            final raw = (event.target as web.HTMLInputElement).value.trim();
            final parsed = int.tryParse(raw);
            // Non-empty but not a non-negative integer (letters,
            // negatives, `-5`, decimals) → clear the filter. Passing
            // null through `copyWith(topicsMin: null)` would leave the
            // previous value in place because our copyWith uses null
            // as "unchanged"; the URL would then silently disagree
            // with what the field shows.
            final invalid = raw.isNotEmpty && (parsed == null || parsed < 0);
            onChange(
              raw.isEmpty || invalid ? query.copyWith(clearTopicsMin: true) : query.copyWith(topicsMin: parsed),
            );
          },
        ),
      ]),
      label(classes: 'sf-field-label', [
        span([.text(l10n.searchFilterTopicsMax)]),
        NeoInput(
          type: 'number',
          value: query.topicsMax?.toString(),
          placeholder: '∞',
          attributes: const {'inputmode': 'numeric', 'min': '0'},
          onInput: (event) {
            final raw = (event.target as web.HTMLInputElement).value.trim();
            final parsed = int.tryParse(raw);
            final invalid = raw.isNotEmpty && (parsed == null || parsed < 0);
            onChange(
              raw.isEmpty || invalid ? query.copyWith(clearTopicsMax: true) : query.copyWith(topicsMax: parsed),
            );
          },
        ),
      ]),
    ]);
  }

  Component _venueBody(Translations l10n) {
    final options = <(SearchVenue, String)>[
      (SearchVenue.any, l10n.searchFilterVenueAny),
      (SearchVenue.online, l10n.searchFilterVenueOnline),
      (SearchVenue.offline, l10n.searchFilterVenueOffline),
    ];
    return div(classes: 'sf-venue', [
      for (final (option, name) in options)
        button(
          classes: [
            'sf-venue-option',
            if (option == query.venue) 'sf-venue-option-active',
          ].join(' '),
          type: ButtonType.button,
          attributes: {'aria-pressed': option == query.venue ? 'true' : 'false'},
          onClick: () => onChange(query.copyWith(venue: option)),
          [.text(name)],
        ),
    ]);
  }

  Component _sortBody(Translations l10n) {
    final options = SearchSortMeta.optionsFor(query.entity);
    return DropdownEditField<SearchSort>(
      id: 'search-sort-${query.entity.slug}',
      items: options,
      value: query.sort,
      itemAsString: (sort) => sort.label(l10n),
      onChange: (sort) {
        if (sort != null) onChange(query.copyWith(sort: sort));
      },
    );
  }

  Component _toggleBadge({
    required String label,
    required bool selected,
    required NeoBadgeTone selectedTone,
    required VoidCallback onToggle,
  }) {
    return button(
      classes: 'sf-badge-btn',
      type: ButtonType.button,
      attributes: {
        'aria-pressed': selected ? 'true' : 'false',
      },
      onClick: onToggle,
      [
        NeoBadge(
          label: label,
          tone: selected ? selectedTone : NeoBadgeTone.neutral,
        ),
      ],
    );
  }

  static NeoBadgeTone _audienceTone(TargetAudience audience) => switch (audience) {
    TargetAudience.schooler => NeoBadgeTone.thematic,
    TargetAudience.student => NeoBadgeTone.student,
    TargetAudience.adult => NeoBadgeTone.hardcore,
  };

  static Set<T> _toggle<T>(Set<T> current, T value) {
    final next = {...current};
    if (!next.add(value)) next.remove(value);
    return next;
  }
}

/// Header + collapsible body. Keeps its own expand/collapse state so
/// user's choice survives parent rebuilds (which happen on every URL
/// change while typing filters).
class _CollapsibleGroup extends StatefulComponent {
  const _CollapsibleGroup({
    required this.title,
    required this.activeCount,
    required this.body,
    super.key,
  });

  final String title;
  final int activeCount;
  final Component body;

  @override
  State<_CollapsibleGroup> createState() => _CollapsibleGroupState();
}

class _CollapsibleGroupState extends State<_CollapsibleGroup> {
  bool _open = true;

  void _toggle() => setState(() => _open = !_open);

  @override
  Component build(BuildContext context) {
    final panelId = 'sf-panel-${identityHashCode(this)}';
    return section(
      classes: [
        'sf-group',
        if (!_open) 'sf-group-collapsed',
      ].join(' '),
      [
        button(
          classes: 'sf-summary',
          type: ButtonType.button,
          attributes: {
            'aria-expanded': _open ? 'true' : 'false',
            'aria-controls': panelId,
          },
          onClick: _toggle,
          [
            span(classes: 'sf-summary-title', [.text(component.title)]),
            if (component.activeCount > 0) span(classes: 'sf-summary-count', [.text(component.activeCount.toString())]),
            span(classes: 'sf-summary-divider', []),
            span(classes: 'sf-summary-chevron', [
              const AppIcon(
                IconPaths.chevronDown,
                width: 14,
                height: 14,
                strokeWidth: '3',
              ),
            ]),
          ],
        ),
        div(
          id: panelId,
          classes: 'sf-body',
          [component.body],
        ),
      ],
    );
  }
}
