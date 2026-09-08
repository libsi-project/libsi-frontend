import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/package_card.dart';
import 'package:sidb/presentation/components/page_container.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/pack/model/question/question.dart';
import 'package:sidb/presentation/features/pack/repository/pack_repository.dart';
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
              [GridTrack(TrackSize.minmax(TrackSize(220.px), .fr(1)))],
            ),
          ],
        ),
      ),
      gap: Gap(row: 0.5.rem, column: 0.6.rem),
    ),
    css('.search-author-card').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.85.rem, vertical: 0.55.rem),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
    css('.search-author-name').styles(
      margin: Margin.zero,
      overflow: Overflow.hidden,
      flex: Flex(grow: 1, shrink: 1),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      whiteSpace: WhiteSpace.noWrap,
      raw: {'text-overflow': 'ellipsis'},
    ),
    css('.search-author-topics').styles(
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
      whiteSpace: WhiteSpace.noWrap,
    ),
    css('.search-topics').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.6.rem),
    ),
    css('.search-topic-card').styles(
      display: Display.flex,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      flexDirection: FlexDirection.column,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)'},
    ),
    css('.search-topic-summary').styles(
      display: Display.flex,
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 0.9.rem, vertical: 0.65.rem),
      border: Border.none,
      cursor: Cursor.pointer,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.left,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.search-topic-summary:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.search-topic-summary:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.search-topic-title').styles(
      margin: Margin.zero,
      overflow: Overflow.hidden,
      flex: Flex(grow: 1, shrink: 1),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.rem,
      fontWeight: FontWeight.w800,
      lineHeight: 1.25.em,
    ),
    css('.search-topic-meta').styles(
      display: Display.flex,
      padding: Padding.only(left: 0.9.rem, right: 0.9.rem, bottom: 0.55.rem),
      flexWrap: FlexWrap.wrap,
      alignItems: AlignItems.baseline,
      gap: Gap(row: 0.15.rem, column: 0.75.rem),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
    ),
    css('.search-topic-meta-link').styles(
      color: AppTheme.textLinkColor,
      textDecoration: const TextDecoration(line: TextDecorationLine.underline),
    ),
    css('.search-topic-meta-link:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.search-topic-count').styles(
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
      whiteSpace: WhiteSpace.noWrap,
    ),
    css('.search-topic-chevron').styles(
      display: Display.inlineFlex,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      transform: Transform.rotate(0.deg),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textSecondary,
    ),
    css('.search-topic-card-open .search-topic-chevron').styles(
      transform: Transform.rotate(180.deg),
    ),
    css('.search-topic-body').styles(
      display: Display.flex,
      padding: Padding.only(left: 0.9.rem, right: 0.9.rem, bottom: 0.9.rem, top: 0.4.rem),
      border: Border.only(
        top: BorderSide.solid(width: 1.px, color: AppTheme.borderColor),
      ),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.6.rem),
    ),
    css('.search-topic-body-header').styles(
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
      textTransform: TextTransform.upperCase,
      raw: {'letter-spacing': '0.05em', 'padding-top': '0.5rem'},
    ),
    css('.search-questions').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.85.rem),
    ),
    css('.search-question-card').styles(
      display: Display.flex,
      padding: Padding.all(1.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
      backgroundColor: AppTheme.canvasColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
    ),
    css('.search-question-source').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 0.25.rem, column: 1.rem),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
      textTransform: TextTransform.upperCase,
      raw: {'letter-spacing': '0.05em'},
    ),
    css('.search-question-source-label').styles(
      color: AppTheme.textSecondary,
    ),
    css('.search-question-source-link').styles(
      color: AppTheme.textLinkColor,
      textDecoration: const TextDecoration(line: TextDecorationLine.underline),
      textTransform: TextTransform.none,
    ),
    css('.search-question-source-link:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.search-question-row').styles(
      display: Display.flex,
      alignItems: AlignItems.start,
      gap: Gap.all(0.75.rem),
    ),
    css('.search-question-points').styles(
      display: Display.inlineFlex,
      width: 40.px,
      height: 40.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.search-question-text-block').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.6.rem),
      flex: Flex(grow: 1),
    ),
    css('.search-question-text').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
    ),
    css('.search-question-answer').styles(
      display: Display.flex,
      padding: Padding.all(0.85.rem),
      border: Border.all(style: BorderStyle.dashed, width: 2.px, color: AppTheme.borderColor),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.5.rem),
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.search-question-answer-row').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.px),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
    ),
    css('.search-question-answer-label').styles(
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.7.rem,
      fontWeight: FontWeight.w800,
      textTransform: TextTransform.upperCase,
      letterSpacing: 0.05.em,
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
    // Wide screens: promote the filter column into the empty gutter
    // left of the centered 1200px page container. The aside floats
    // absolutely against `.search-layout` (which becomes the
    // positioning anchor), so results reclaim the whole page width.
    // The 1700px threshold is the point where a 240px filter + 20px
    // gap comfortably fits into the left-hand gutter without
    // clipping.
    css.media(MediaQuery.screen(minWidth: 1700.px), [
      css('.search-layout').styles(position: Position.relative()),
      css('.search-body').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(.fr(1))]),
        ),
      ),
      css('.search-body-narrow').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(.fr(1))]),
        ),
      ),
      css('.search-filters').styles(
        position: Position.absolute(top: 0.px),
        width: 240.px,
        raw: {
          'right': 'calc(100% + 20px)',
          'left': 'auto',
        },
      ),
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
            if (query.query.isNotEmpty)
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
      case SearchEntity.tournaments:
        final filtered = _filterPacks(packs);
        if (filtered.isEmpty) return _state(l10n.searchNoResults);
        return div(
          classes: 'search-grid',
          filtered.map((pack) => PackageCard(pack: pack)).toList(),
        );
      case SearchEntity.questions:
        final filtered = _filterPacks(packs);
        if (filtered.isEmpty) return _state(l10n.searchNoResults);
        return _QuestionsFeed(packs: filtered, query: query, l10n: l10n);
      case SearchEntity.topics:
        final rows = _filterTopics(packs);
        if (rows.isEmpty) return _state(l10n.searchNoResults);
        return div(classes: 'search-topics', rows.map(_topicCard).toList());
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
    // On question/topic tabs the free-text query applies to the
    // topic/question content, not the pack title — so we only run
    // the text check on tournaments/authors here. The other tabs
    // filter items after generating them.
    final applyTextToPack =
        needle.isNotEmpty && query.entity != SearchEntity.questions && query.entity != SearchEntity.topics;
    final filtered = packs.where((pack) {
      if (applyTextToPack &&
          !pack.title.toLowerCase().contains(needle) &&
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
    // Aggregate every author present in the catalogue when there's no
    // query text; when the user narrows by text, only keep packs where
    // an author's name matches so pack-level counts stay honest.
    final matching = needle.isEmpty
        ? packs
        : packs.where((pack) => pack.authors.any((author) => author.name.toLowerCase().contains(needle))).toList();
    final summaries = AuthorSummary.fromPacks(
      matching.toList(),
    ).where((entry) => needle.isEmpty || entry.author.name.toLowerCase().contains(needle)).toList();
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

  List<_TopicRow> _filterTopics(List<Pack> packs) {
    final needle = query.query.toLowerCase();
    final scopes = query.effectiveScopes;
    // Run pack-level filters first so the audience/game-type/date
    // chips also narrow the topic feed — otherwise Topics would ignore
    // filters that the sibling tabs honour.
    final rows = <_TopicRow>[];
    for (final pack in _filterPacks(packs)) {
      for (final topic in _mockTopicsFor(pack)) {
        if (needle.isNotEmpty && !_topicMatches(topic, needle, scopes)) continue;
        rows.add(_TopicRow(pack: pack, topic: topic));
      }
    }
    rows.sort(_topicComparator());
    return rows;
  }

  bool _topicMatches(_MockTopic topic, String needle, Set<SearchScope> scopes) {
    if (scopes.contains(SearchScope.title) && topic.title.toLowerCase().contains(needle)) {
      return true;
    }
    for (final question in topic.questions) {
      if (_questionMatches(question, needle, scopes)) return true;
    }
    return false;
  }

  int Function(_TopicRow, _TopicRow) _topicComparator() {
    return switch (query.sort) {
      SearchSort.titleAsc => (left, right) => left.topic.title.toLowerCase().compareTo(right.topic.title.toLowerCase()),
      SearchSort.titleDesc => (left, right) => right.topic.title.toLowerCase().compareTo(
        left.topic.title.toLowerCase(),
      ),
      _ => (_, _) => 0,
    };
  }

  Component _topicCard(_TopicRow row) {
    return _TopicFeedCard(key: ValueKey('${row.pack.id}#${row.topic.id}'), row: row, l10n: l10n);
  }

  Component _authorCard(AuthorSummary summary) {
    return NeoCard(
      classes: 'search-author-card',
      children: [
        h3(classes: 'search-author-name', [.text(summary.author.name)]),
        span(classes: 'search-author-topics', [
          .text(l10n.searchAuthorTopicsCount(n: summary.totalTopics)),
        ]),
      ],
    );
  }

  static bool _questionMatches(Question question, String needle, Set<SearchScope> scopes) {
    if (scopes.contains(SearchScope.question) && question.text.toLowerCase().contains(needle)) {
      return true;
    }
    if (scopes.contains(SearchScope.answer)) {
      if (question.answer.toLowerCase().contains(needle)) return true;
      final extra = question.additionalAnswers;
      if (extra != null && extra.toLowerCase().contains(needle)) return true;
    }
    if (scopes.contains(SearchScope.comment)) {
      final comment = question.comment;
      if (comment != null && comment.toLowerCase().contains(needle)) return true;
    }
    if (scopes.contains(SearchScope.source)) {
      final source = question.source;
      if (source != null && source.toLowerCase().contains(needle)) return true;
    }
    return false;
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

/// A single topic row surfaced on the Topics tab. Carries its parent
/// pack so we can render tournament links and drop the click straight
/// onto `/pack/:id#topic-:tid`.
class _TopicRow {
  const _TopicRow({required this.pack, required this.topic});
  final Pack pack;
  final _MockTopic topic;
}

/// Random-picked questions from filtered packs. Uses a deterministic
/// shuffle seed derived from the pack list length + the URL query so
/// the same result set stays visible across widget rebuilds within a
/// session — but tweaking a filter (which changes the URL) reshuffles.
class _QuestionsFeed extends StatelessComponent {
  const _QuestionsFeed({
    required this.packs,
    required this.query,
    required this.l10n,
  });

  final List<Pack> packs;
  final SearchQuery query;
  final Translations l10n;

  static const int _feedSize = 12;

  @override
  Component build(BuildContext context) {
    final items = _pickItems();
    if (items.isEmpty) return p(classes: 'search-question-empty', [.text(l10n.searchNoResults)]);
    return div(
      classes: 'search-questions',
      [for (final item in items) _QuestionFeedCard(key: ValueKey(item.anchorKey), item: item, l10n: l10n)],
    );
  }

  List<_QuestionFeedItem> _pickItems() {
    final needle = query.query.toLowerCase();
    final scopes = query.effectiveScopes;
    final all = <_QuestionFeedItem>[];
    for (final pack in packs) {
      for (final topic in _mockTopicsFor(pack)) {
        final topicTitleMatches = scopes.contains(SearchScope.title) && topic.title.toLowerCase().contains(needle);
        for (final question in topic.questions) {
          if (needle.isNotEmpty && !topicTitleMatches && !_SearchResults._questionMatches(question, needle, scopes)) {
            continue;
          }
          all.add(_QuestionFeedItem(pack: pack, topic: topic, question: question));
        }
      }
    }
    if (all.isEmpty) return const [];
    final random = Random(packs.length * 31 + _stableHash(query.toUrl()));
    all.shuffle(random);
    return all.take(_feedSize).toList();
  }
}

/// Deterministic string hash independent of the runtime — `String.hashCode`
/// differs between the Dart VM and dart2js, which would reshuffle the
/// question feed and rotate topic titles between hydration and client
/// re-render. Uses the classic FNV-style 31·h + code unit fold clamped
/// to 29 bits to stay inside `Random`'s positive-int seed range.
int _stableHash(String value) {
  var hash = 0;
  for (final unit in value.codeUnits) {
    hash = (hash * 31 + unit) & 0x1fffffff;
  }
  return hash;
}

/// Mirror of `ApiPackRepository._mockTopics` — kept module-private
/// while questions/topics live client-side. Drop when a real API
/// exposes topic bodies for a pack.
List<_MockTopic> _mockTopicsFor(Pack pack) {
  final titles = ApiPackRepository.mockTopicTitles;
  final topicCount = pack.topicsCount.clamp(1, 6).toInt();
  final startOffset = _stableHash(pack.id) % titles.length;
  return [
    for (var i = 0; i < topicCount; i++)
      () {
        final index = i + 1;
        final title = titles[(startOffset + i) % titles.length];
        return _MockTopic(
          id: index,
          title: title,
          questions: [
            for (var q = 0; q < 5; q++)
              Question(
                id: index * 100 + q,
                text:
                    'Вопрос за ${(q + 1) * 10} очков в теме «$title». '
                    'Здесь будет полный текст вопроса из пакета, отображаемый до раскрытия ответа.',
                answer: 'Ответ на вопрос за ${(q + 1) * 10} очков',
                additionalAnswers: q.isEven ? 'Также принимается: вариант A, вариант B' : null,
                wrongAnswers: q == 2 ? 'Не принимается: очевидно неверный ответ' : null,
                comment: q == 0 ? 'Комментарий: контекст и пояснение к вопросу' : null,
                source: q == 4 ? 'Источник: https://example.org' : null,
              ),
          ],
        );
      }(),
  ];
}

class _MockTopic {
  const _MockTopic({required this.id, required this.title, required this.questions});
  final int id;
  final String title;
  final List<Question> questions;
}

@immutable
class _QuestionFeedItem {
  const _QuestionFeedItem({required this.pack, required this.topic, required this.question});

  final Pack pack;
  final _MockTopic topic;
  final Question question;

  /// Stable key that survives shuffles across rebuilds — pack id +
  /// topic id + question id is unique across the whole catalogue.
  String get anchorKey => '${pack.id}#${topic.id}#${question.id}';
}

class _QuestionFeedCard extends StatefulComponent {
  const _QuestionFeedCard({
    required this.item,
    required this.l10n,
    this.showSource = true,
    super.key,
  });

  final _QuestionFeedItem item;
  final Translations l10n;

  /// Rendered inside a topic card the tournament/topic labels would
  /// duplicate the card header, so callers can suppress them.
  final bool showSource;

  @override
  State<_QuestionFeedCard> createState() => _QuestionFeedCardState();
}

class _QuestionFeedCardState extends State<_QuestionFeedCard> {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  @override
  Component build(BuildContext context) {
    final l10n = component.l10n;
    final item = component.item;
    // Nominal 10/20/30/40/50 mirrors PackQuestionCard — positional
    // within the topic and derived from the mock id scheme.
    final position = item.question.id % 100;
    final points = (position + 1) * 10;
    return article(
      classes: 'search-question-card',
      [
        if (component.showSource)
          div(classes: 'search-question-source', [
            span(classes: 'search-question-source-label', [
              .text('${l10n.searchQuestionFromTournament}: '),
            ]),
            router.Link(
              to: '/pack/${item.pack.id}',
              classes: 'search-question-source-link',
              child: Component.text(item.pack.title),
            ),
            span(classes: 'search-question-source-label', [
              .text('${l10n.searchQuestionFromTopic}: '),
            ]),
            router.Link(
              to: '/pack/${item.pack.id}#topic-${item.topic.id}',
              classes: 'search-question-source-link',
              child: Component.text(item.topic.title),
            ),
          ]),
        div(classes: 'search-question-row', [
          span(classes: 'search-question-points', [.text('$points')]),
          div(classes: 'search-question-text-block', [
            p(classes: 'search-question-text', [.text(item.question.text)]),
            NeoButton(
              variant: _open ? NeoButtonVariant.accent : NeoButtonVariant.surface,
              size: NeoButtonSize.sm,
              onClick: _toggle,
              styles: Styles(radius: NeoTokens.radius(NeoTokens.radiusNone)),
              attributes: {'aria-expanded': _open ? 'true' : 'false'},
              children: [.text(_open ? l10n.hideAnswer : l10n.showAnswer)],
            ),
          ]),
        ]),
        if (_open) _answer(l10n, item.question),
      ],
    );
  }

  Component _answer(Translations l10n, Question question) {
    return div(classes: 'search-question-answer', [
      _row(l10n.questionAnswer, question.answer),
      if ((question.additionalAnswers ?? '').isNotEmpty)
        _row(l10n.questionAdditionalAnswers, question.additionalAnswers!),
      if ((question.wrongAnswers ?? '').isNotEmpty) _row(l10n.questionWrongAnswers, question.wrongAnswers!),
      if ((question.comment ?? '').isNotEmpty) _row(l10n.questionComment, question.comment!),
      if ((question.source ?? '').isNotEmpty) _row(l10n.questionSource, question.source!),
    ]);
  }

  Component _row(String label, String value) {
    return div(classes: 'search-question-answer-row', [
      span(classes: 'search-question-answer-label', [.text(label)]),
      span([.text(value)]),
    ]);
  }
}

/// Collapsible topic card for the Topics search tab. The summary
/// header carries the topic title, tournament link (→ pack page),
/// and author list; expanding reveals the topic's questions using
/// the same expand-answer pattern as the questions feed.
class _TopicFeedCard extends StatefulComponent {
  const _TopicFeedCard({required this.row, required this.l10n, super.key});

  final _TopicRow row;
  final Translations l10n;

  @override
  State<_TopicFeedCard> createState() => _TopicFeedCardState();
}

class _TopicFeedCardState extends State<_TopicFeedCard> {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  @override
  Component build(BuildContext context) {
    final l10n = component.l10n;
    final row = component.row;
    final pack = row.pack;
    final topic = row.topic;
    final authors = pack.authors.map((author) => author.name).join(' · ');
    return section(
      classes: ['search-topic-card', if (_open) 'search-topic-card-open'].join(' '),
      [
        button(
          classes: 'search-topic-summary',
          type: ButtonType.button,
          attributes: {'aria-expanded': _open ? 'true' : 'false'},
          onClick: _toggle,
          [
            h3(classes: 'search-topic-title', [.text(topic.title)]),
            span(classes: 'search-topic-count', [
              .text(l10n.searchTopicQuestionsCount(n: topic.questions.length)),
            ]),
            span(classes: 'search-topic-chevron', [
              const AppIcon(IconPaths.chevronDown, width: 16, height: 16, strokeWidth: '3'),
            ]),
          ],
        ),
        // Meta line lives outside the toggle button — `router.Link`
        // renders an `<a>`, which HTML disallows inside interactive
        // content, and its activation would otherwise bubble to the
        // toggle and both navigate and expand.
        div(classes: 'search-topic-meta', [
          span([.text('${l10n.searchQuestionFromTournament}: ')]),
          router.Link(
            to: '/pack/${pack.id}',
            classes: 'search-topic-meta-link',
            child: Component.text(pack.title),
          ),
          if (authors.isNotEmpty) span([.text('· $authors')]),
        ]),
        if (_open)
          div(classes: 'search-topic-body', [
            for (final question in topic.questions)
              _QuestionFeedCard(
                key: ValueKey('topic-q-${pack.id}-${topic.id}-${question.id}'),
                item: _QuestionFeedItem(pack: pack, topic: topic, question: question),
                l10n: l10n,
                showSource: false,
              ),
          ]),
      ],
    );
  }
}
