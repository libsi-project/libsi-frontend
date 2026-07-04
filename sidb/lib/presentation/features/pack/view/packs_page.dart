import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/core/di/di.dart';
import 'package:sidb/presentation/components/package_card.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/features/pack/model/pack.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';

class PacksPage extends StatefulComponent {
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
  State<PacksPage> createState() => _PacksPageState();
}

class _PacksPageState extends State<PacksPage> {
  late final PackBloc _packBloc;

  @override
  void initState() {
    super.initState();
    _packBloc = PackBloc(getIt<PackUseCase>())..add(GetPacksEvent());
  }

  @override
  Component build(BuildContext context) {
    return BlocBuilder<PackBloc, PackState>(
      bloc: _packBloc,
      builder: (context, state) {
        if (state is PackLoadingState) {
          return _pageShell([
            p(
              styles: Styles(fontSize: 1.1.rem, fontWeight: FontWeight.w700),
              [.text('Загружаем пакеты...')],
            ),
          ]);
        }
        if (state is PackErrorState || state is PackLoadedState) {
          return _pageShell([
            div(
              classes: 'package-grid',
              _mockPacks.map((pack) => PackageCard(pack: pack)).toList(),
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
      padding: Padding.only(left: 2.rem, right: 2.rem, top: 3.rem, bottom: 3.rem),
    ),
    children,
  );
}

final _mockPacks = List<Pack>.generate(
  8,
  (idx) => Pack(
    id: 'mock-$idx',
    title: 'BUG MAJOR 3\nБуг Мажор 2',
    gameType: 'ИСИ',
    difficultyType: 'Школьный',
    difficulty: 'Средне',
    authors: const [
      'Алексей Кураев',
      'Иван Дрозд',
      'Михаил Карпук',
      'Константин Насковец',
      'Максим Гиндеров',
      'Григорий Зырянов',
      'Никита Шевела',
      'и другие...',
    ],
    topicsCount: 52,
    publishDate: DateTime(2023, 5, 14),
    playDate: DateTime(2023, 5, 20),
    likesCount: 10,
    dislikesCount: 2,
  ),
);
