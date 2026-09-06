import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/package_card.dart';
import 'package:sidb/presentation/components/page_container.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

// TODO: replace client-side title filter with a backend search endpoint
// that matches question text, as required by issue #16 (AC 2). Once
// available, dispatch a SearchPacksEvent to PackBloc and drop the local
// filter here.
class SearchPage extends StatelessComponent {
  const SearchPage({super.key});

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final query = router.RouteState.of(context).queryParams['q']?.trim() ?? '';

    if (query.isEmpty) {
      return _shell([_stateText(l10n.searchPrompt)]);
    }

    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PackLoadingState) {
          return _shell([_stateText(l10n.loadingPacks)]);
        }
        if (state is PackErrorState) {
          return _shell([
            _stateText('${l10n.packsLoadError}: ${state.error}'),
          ]);
        }
        if (state is PackLoadedState) {
          final results = _filter(state.packs, query);
          return _shell([
            h1(
              styles: NeoStyles.text(
                family: NeoTokens.fontDisplay,
                size: 1.75,
                weight: FontWeight.w800,
              ),
              [.text(l10n.searchResultsFor(query: query))],
            ),
            if (results.isEmpty)
              _stateText(l10n.searchNoResults)
            else
              div(
                classes: 'search-results-grid',
                results.map((pack) => PackageCard(pack: pack)).toList(),
              ),
          ]);
        }
        return const div([]);
      },
    );
  }

  static List<Pack> _filter(List<Pack> packs, String query) {
    final normalized = query.toLowerCase();
    return packs.where((pack) => pack.title.toLowerCase().contains(normalized)).toList();
  }

  @css
  static List<StyleRule> get styles => [
    css('.search-results-grid').styles(
      display: Display.grid,
      width: 100.percent,
      justifyContent: JustifyContent.center,
      gridTemplate: GridTemplate(
        columns: GridTracks(
          [
            GridTrack.repeat(
              TrackRepeat.autoFit,
              [
                GridTrack(
                  TrackSize.minmax(TrackSize(220.px), TrackSize(300.px)),
                ),
              ],
            ),
          ],
        ),
      ),
      justifyItems: JustifyItems.center,
      gap: Gap(row: 1.5.rem, column: 30.px),
    ),
    css.media(MediaQuery.screen(minWidth: 768.px), [
      css('.search-results-grid').styles(
        justifyContent: JustifyContent.start,
        justifyItems: JustifyItems.start,
      ),
    ]),
  ];
}

Component _shell(List<Component> children) {
  return PageContainer(
    styles: Styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 20.px, vertical: 3.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.5.rem),
    ),
    children: children,
  );
}

Component _stateText(String text) {
  return p(
    styles: NeoStyles.text(
      color: AppTheme.textColor,
      size: 1.1,
      weight: FontWeight.w700,
    ),
    [.text(text)],
  );
}
