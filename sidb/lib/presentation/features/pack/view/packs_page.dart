import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/package_card.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class PacksPage extends StatelessComponent {
  const PacksPage({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.package-grid').styles(
      display: Display.grid,
      justifyContent: JustifyContent.start,
      gridTemplate: GridTemplate(
        columns: GridTracks(
          [
            GridTrack.repeat(
              TrackRepeat.autoFit,
              [
                GridTrack(
                  TrackSize.minmax(TrackSize(240.px), .fr(1)),
                ),
              ],
            ),
          ],
        ),
      ),
      justifyItems: JustifyItems.start,
      gap: Gap(row: 1.5.rem, column: 30.px),
    ),
    css.media(MediaQuery.screen(minWidth: 768.px), [
      css('.package-grid').styles(
        gap: Gap(row: 1.5.rem, column: 30.px),
      ),
    ]),
    css.media(MediaQuery.screen(minWidth: 1024.px), [
      css('.package-grid').styles(
        gap: Gap(row: 1.75.rem, column: 30.px),
      ),
    ]),
    css.media(MediaQuery.screen(minWidth: 1280.px), [
      css('.package-grid').styles(
        gap: Gap(row: 2.rem, column: 30.px),
      ),
    ]),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PackLoadingState) {
          return _pageShell([_stateText(l10n.loadingPacks)]);
        }
        if (state is PackErrorState) {
          return _pageShell([
            _stateText('${l10n.packsLoadError}: ${state.error}'),
          ]);
        }
        if (state is PackLoadedState) {
          if (state.packs.isEmpty) {
            return _pageShell([_stateText(l10n.emptyPacks)]);
          }
          return _pageShell([
            div(
              classes: 'package-grid',
              state.packs.map((pack) => PackageCard(pack: pack)).toList(),
            ),
          ]);
        }
        return const div([]);
      },
    );
  }
}

Component _pageShell(List<Component> children) {
  return div(
    styles: Styles(
      padding: Padding.symmetric(vertical: 3.rem),
    ),
    children,
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
