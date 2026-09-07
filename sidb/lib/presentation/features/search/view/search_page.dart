import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_badge.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/package_card.dart';
import 'package:sidb/presentation/components/page_container.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/search/model/search_query.dart';
import 'package:sidb/presentation/features/search/view/search_filters.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Search screen. Owns no state of its own — everything is read from
/// the URL and every user action rewrites the URL, so the /search
/// route can be linked, refreshed, or pasted and land the reader on
/// the exact same view.
class SearchPage extends StatelessComponent {
  const SearchPage({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.search-layout').styles(
      display: Display.grid,
      width: 100.percent,
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(.fr(1))]),
      ),
      gap: Gap(row: 1.25.rem, column: 1.5.rem),
    ),
    css('.search-header').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.85.rem),
    ),
    css('.search-tabs').styles(
      display: Display.inlineFlex,
      padding: Padding.all(4.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      alignSelf: AlignSelf.start,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)'},
    ),
    css('.search-tab').styles(
      padding: Padding.symmetric(horizontal: 0.9.rem, vertical: 0.4.rem),
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      appearance: Appearance.none,
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.search-tab:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.search-tab-active').styles(
      color: AppTheme.onPrimaryColor,
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.search-tab-active:hover').styles(
      backgroundColor: AppTheme.primaryColor,
    ),
    css('.search-tab:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.search-search-bar').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
    css('.search-search-bar .search-field').styles(
      flex: Flex(grow: 1),
    ),
    css('.search-filters-toggle').styles(
      display: Display.inlineFlex,
      flex: Flex(shrink: 0),
    ),
    css('.search-body').styles(
      display: Display.grid,
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(.fr(1))]),
      ),
      gap: Gap(row: 1.25.rem, column: 1.5.rem),
    ),
    css('.search-filters').styles(
      display: Display.none,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      overflow: Overflow.visible,
      flexDirection: FlexDirection.column,
      alignSelf: AlignSelf.start,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
    ),
    css('.search-filters-open').styles(display: Display.flex),
    css('.search-filters-head').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.85.rem, vertical: 0.55.rem),
      border: Border.only(
        bottom: BorderSide.solid(width: 2.px, color: AppTheme.borderColor),
      ),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
      backgroundColor: AppTheme.canvasColor,
    ),
    css('.search-filters-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      textTransform: TextTransform.upperCase,
      raw: {'letter-spacing': '0.04em'},
    ),
    css('.search-filters-reset').styles(
      padding: Padding.symmetric(horizontal: 0.55.rem, vertical: 0.25.rem),
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      color: AppTheme.textLinkColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.8.rem,
      fontWeight: FontWeight.w800,
      textDecoration: const TextDecoration(line: TextDecorationLine.underline),
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.search-filters-reset:hover').styles(
      textDecoration: TextDecoration.none,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.search-filters-reset:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.search-filters-collapse').styles(
      display: Display.inlineFlex,
      width: 28.px,
      height: 28.px,
      padding: Padding.zero,
      border: NeoTokens.border(color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.rotate(0.deg),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textSecondary,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.search-filters-collapse:hover').styles(
      border: NeoTokens.border(),
      color: AppTheme.textColor,
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.search-filters-collapse:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.search-filters-collapsed .search-filters-collapse').styles(
      transform: Transform.rotate((-90).deg),
    ),
    css('.search-filters-collapsed .search-filters-body').styles(display: Display.none),
    css('.search-filters-collapsed .search-filters-actions').styles(display: Display.none),
    css('.search-filters-collapsed .search-filters-head').styles(
      border: Border.none,
    ),
    css('.search-filters-body').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.85.rem, vertical: 0.9.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.1.rem),
    ),
    css('.search-filters-actions').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.85.rem, vertical: 0.6.rem),
      border: Border.only(
        top: BorderSide.solid(width: 1.px, color: AppTheme.borderColor),
      ),
      justifyContent: JustifyContent.end,
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
    ),
    css('.search-results').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
    ),
    css('.search-results-heading').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.35.rem,
      fontWeight: FontWeight.w800,
    ),
    css('.search-grid').styles(
      display: Display.grid,
      gridTemplate: GridTemplate(
        columns: GridTracks(
          [
            GridTrack.repeat(
              TrackRepeat.autoFit,
              [GridTrack(TrackSize.minmax(TrackSize(220.px), .fr(1)))],
            ),
          ],
        ),
      ),
      gap: Gap(row: 1.5.rem, column: 20.px),
    ),
    css('.search-authors-grid').styles(
      display: Display.grid,
      gridTemplate: GridTemplate(
        columns: GridTracks(
          [
            GridTrack.repeat(
              TrackRepeat.autoFit,
              [GridTrack(TrackSize.minmax(TrackSize(240.px), .fr(1)))],
            ),
          ],
        ),
      ),
      gap: Gap(row: 1.rem, column: 1.rem),
    ),
    css('.search-author-card').styles(
      display: Display.flex,
      minHeight: 130.px,
      padding: Padding.all(1.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.4.rem),
    ),
    css('.search-author-name').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.15.rem,
      fontWeight: FontWeight.w800,
    ),
    css('.search-author-meta').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 0.25.rem, column: 0.85.rem),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
    ),
    css.media(MediaQuery.screen(minWidth: 768.px), [
      css('.search-body').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize(260.px)), GridTrack(.fr(1))]),
        ),
      ),
      css('.search-body-narrow').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.auto), GridTrack(.fr(1))]),
        ),
      ),
      css('.search-filters').styles(display: Display.flex),
      css('.search-filters-toggle').styles(display: Display.none),
      css('.search-filters-actions').styles(display: Display.none),
    ]),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final params = router.RouteState.of(context).queryParams;
    final query = SearchQuery.fromParams(params);
    return PageContainer(
      styles: Styles(
        padding: Padding.symmetric(horizontal: 20.px, vertical: 2.rem),
      ),
      children: [
        _SearchScreen(
          l10n: l10n,
          query: query,
        ),
      ],
    );
  }
}

class _SearchScreen extends StatefulComponent {
  const _SearchScreen({
    required this.l10n,
    required this.query,
  });

  final Translations l10n;
  final SearchQuery query;

  @override
  State<_SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<_SearchScreen> {
  bool _filtersOpen = false;
  bool _filtersCollapsed = false;

  void _navigate(SearchQuery next) {
    router.Router.of(context).replace(next.toUrl());
  }

  void _onSubmit(String text) {
    _navigate(component.query.copyWith(query: text));
  }

  void _onEntityChange(SearchEntity entity) {
    _navigate(component.query.withEntity(entity));
  }

  void _onFiltersChange(SearchQuery next) {
    _navigate(next);
  }

  void _onReset() {
    // Use the entity's own default sort — the SearchQuery constructor
    // defaults to `relevance`, which is not a valid option on the
    // authors tab. Without this, resetting on /authors would encode
    // `sort=relevance` in the URL and keep `hasFilters == true`.
    _navigate(
      SearchQuery(
        entity: component.query.entity,
        query: component.query.query,
        sort: SearchSortMeta.optionsFor(component.query.entity).first,
      ),
    );
    setState(() => _filtersOpen = false);
  }

  @override
  Component build(BuildContext context) {
    final l10n = component.l10n;
    final query = component.query;
    return div(classes: 'search-layout', [
      div(classes: 'search-header', [
        _EntityTabs(entity: query.entity, onChange: _onEntityChange, l10n: l10n),
        div(classes: 'search-search-bar', [
          SearchField(
            key: ValueKey('search-field-${query.entity.slug}'),
            placeholder: query.entity.placeholder(l10n),
            initialValue: query.query,
            searchLabel: l10n.search,
            onSubmit: _onSubmit,
          ),
          NeoButton(
            classes: 'search-filters-toggle',
            variant: NeoButtonVariant.surface,
            size: NeoButtonSize.md,
            attributes: {
              'aria-expanded': _filtersOpen ? 'true' : 'false',
              // The mobile toggle shows/hides the whole aside; the
              // inner body is what the desktop chevron controls.
              'aria-controls': 'search-filters-aside',
            },
            onClick: () => setState(() => _filtersOpen = !_filtersOpen),
            children: [
              span([
                .text(_filtersOpen ? l10n.searchCloseFilters : l10n.searchOpenFilters),
              ]),
            ],
          ),
        ]),
      ]),
      div(
        classes: [
          'search-body',
          if (_filtersCollapsed) 'search-body-narrow',
        ].join(' '),
        [
          aside(
            id: 'search-filters-aside',
            classes: [
              'search-filters',
              if (_filtersOpen) 'search-filters-open',
              if (_filtersCollapsed) 'search-filters-collapsed',
            ].join(' '),
            attributes: {'aria-label': l10n.searchFiltersTitle},
            [
              div(classes: 'search-filters-head', [
                h2(classes: 'search-filters-title', [.text(l10n.searchFiltersTitle)]),
                if (query.hasFilters)
                  button(
                    classes: 'search-filters-reset',
                    type: ButtonType.button,
                    onClick: _onReset,
                    [.text(l10n.searchResetFilters)],
                  ),
                button(
                  classes: 'search-filters-collapse',
                  type: ButtonType.button,
                  attributes: {
                    'aria-expanded': _filtersCollapsed ? 'false' : 'true',
                    'aria-controls': 'search-filters-panel',
                    'aria-label': _filtersCollapsed ? l10n.searchExpandFiltersColumn : l10n.searchCollapseFiltersColumn,
                    'title': _filtersCollapsed ? l10n.searchExpandFiltersColumn : l10n.searchCollapseFiltersColumn,
                  },
                  onClick: () => setState(() => _filtersCollapsed = !_filtersCollapsed),
                  [
                    const AppIcon(
                      IconPaths.chevronDown,
                      width: 18,
                      height: 18,
                      strokeWidth: '3',
                    ),
                  ],
                ),
              ]),
              div(
                id: 'search-filters-panel',
                classes: 'search-filters-body',
                [
                  SearchFilters(query: query, onChange: _onFiltersChange),
                ],
              ),
              div(classes: 'search-filters-actions', [
                NeoButton(
                  variant: NeoButtonVariant.primary,
                  size: NeoButtonSize.sm,
                  onClick: () => setState(() => _filtersOpen = false),
                  children: [.text(l10n.searchApplyFilters)],
                ),
              ]),
            ],
          ),
          _SearchResults(query: query, l10n: l10n),
        ],
      ),
    ]);
  }
}

class _EntityTabs extends StatelessComponent {
  const _EntityTabs({
    required this.entity,
    required this.onChange,
    required this.l10n,
  });

  final SearchEntity entity;
  final ValueChanged<SearchEntity> onChange;
  final Translations l10n;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'search-tabs',
      attributes: const {'role': 'tablist'},
      [
        for (final option in SearchEntity.values)
          button(
            classes: [
              'search-tab',
              if (option == entity) 'search-tab-active',
            ].join(' '),
            type: ButtonType.button,
            attributes: {
              'role': 'tab',
              'aria-selected': option == entity ? 'true' : 'false',
            },
            onClick: option == entity ? null : () => onChange(option),
            [.text(option.label(l10n))],
          ),
      ],
    );
  }
}

class _SearchResults extends StatelessComponent {
  const _SearchResults({required this.query, required this.l10n});

  final SearchQuery query;
  final Translations l10n;

  @override
  Component build(BuildContext context) {
    if (query.query.isEmpty) {
      return div(classes: 'search-results', [_state(l10n.searchPrompt)]);
    }

    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PackLoadingState) {
          return div(classes: 'search-results', [_state(l10n.loadingPacks)]);
        }
        if (state is PackErrorState) {
          return div(classes: 'search-results', [
            _state('${l10n.packsLoadError}: ${state.error}'),
          ]);
        }
        if (state is PackLoadedState) {
          return div(classes: 'search-results', [
            h1(classes: 'search-results-heading', [
              .text(l10n.searchResultsFor(query: query.query)),
            ]),
            _renderResults(state.packs),
          ]);
        }
        return const div([]);
      },
    );
  }

  Component _renderResults(List<Pack> packs) {
    switch (query.entity) {
      case SearchEntity.questions:
      case SearchEntity.tournaments:
        final filtered = _filterPacks(packs);
        if (filtered.isEmpty) return _state(l10n.searchNoResults);
        return div(
          classes: 'search-grid',
          filtered.map((pack) => PackageCard(pack: pack)).toList(),
        );
      case SearchEntity.authors:
        final authors = _filterAuthors(packs);
        if (authors.isEmpty) return _state(l10n.searchNoResults);
        return div(
          classes: 'search-authors-grid',
          authors.map(_authorCard).toList(),
        );
    }
  }

  List<Pack> _filterPacks(List<Pack> packs) {
    final needle = query.query.toLowerCase();
    final filtered = packs.where((pack) {
      if (!pack.title.toLowerCase().contains(needle) &&
          !pack.authors.any((author) => author.name.toLowerCase().contains(needle))) {
        return false;
      }
      if (query.audiences.isNotEmpty && !pack.audiences.any(query.audiences.contains)) {
        return false;
      }
      if (query.gameTypes.isNotEmpty && !query.gameTypes.contains(pack.gameType)) {
        return false;
      }
      if (query.playFrom != null && pack.playDate.isBefore(query.playFrom!)) {
        return false;
      }
      // Treat `playTo` as inclusive of the whole selected day. Packs
      // played on that date but at a non-midnight time would
      // otherwise be excluded because `SearchQuery` parses dates at
      // 00:00 while `Pack.playDate` restores a full timestamp.
      final playTo = query.playTo;
      if (playTo != null && !pack.playDate.isBefore(DateTime(playTo.year, playTo.month, playTo.day + 1))) {
        return false;
      }
      if (query.topicsMin != null && pack.topicsCount < query.topicsMin!) {
        return false;
      }
      if (query.topicsMax != null && pack.topicsCount > query.topicsMax!) {
        return false;
      }
      return true;
    }).toList();
    filtered.sort(_packComparator());
    return filtered;
  }

  int Function(Pack, Pack) _packComparator() {
    return switch (query.sort) {
      SearchSort.newest => (left, right) => right.publishDate.compareTo(left.publishDate),
      SearchSort.oldest => (left, right) => left.publishDate.compareTo(right.publishDate),
      SearchSort.mostLiked => (left, right) => right.likesCount.compareTo(left.likesCount),
      SearchSort.titleAsc => (left, right) => left.title.toLowerCase().compareTo(right.title.toLowerCase()),
      SearchSort.titleDesc => (left, right) => right.title.toLowerCase().compareTo(left.title.toLowerCase()),
      _ => (_, _) => 0,
    };
  }

  List<AuthorSummary> _filterAuthors(List<Pack> packs) {
    final needle = query.query.toLowerCase();
    final matching = packs.where(
      (pack) => pack.authors.any((author) => author.name.toLowerCase().contains(needle)),
    );
    final summaries = AuthorSummary.fromPacks(
      matching.toList(),
    ).where((entry) => entry.author.name.toLowerCase().contains(needle)).toList();
    summaries.sort(_authorComparator());
    return summaries;
  }

  int Function(AuthorSummary, AuthorSummary) _authorComparator() {
    return switch (query.sort) {
      SearchSort.authorDesc => (left, right) => right.author.name.toLowerCase().compareTo(
        left.author.name.toLowerCase(),
      ),
      SearchSort.authorPacks => (left, right) => right.packsCount.compareTo(left.packsCount),
      _ => (left, right) => left.author.name.toLowerCase().compareTo(
        right.author.name.toLowerCase(),
      ),
    };
  }

  Component _authorCard(AuthorSummary summary) {
    return NeoCard(
      classes: 'search-author-card',
      children: [
        h3(classes: 'search-author-name', [.text(summary.author.name)]),
        div(classes: 'search-author-meta', [
          NeoBadge(
            label: l10n.searchAuthorPacksCount(n: summary.packsCount),
            tone: NeoBadgeTone.thematic,
          ),
          span([.text('♥ ${summary.totalLikes}')]),
          if (summary.latestPlayDate != null) span([.text(l10n.searchYearOnly(year: summary.latestPlayDate!.year))]),
        ]),
      ],
    );
  }

  static Component _state(String text) {
    return p(
      styles: NeoStyles.text(
        color: AppTheme.textColor,
        size: 1.05,
        weight: FontWeight.w700,
      ),
      [.text(text)],
    );
  }
}
