import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/core/di/di.dart';
import 'package:sidb/presentation/components/neo_badge.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/features/not_found/view/not_found_page.dart';
import 'package:sidb/presentation/features/pack/model/detailed_package/detailed_package.dart';
import 'package:sidb/presentation/features/pack/model/game_type/game_type.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';
import 'package:sidb/presentation/features/pack/model/topic/topic.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';
import 'package:sidb/presentation/features/pack_details/bloc/pack_details_bloc.dart';
import 'package:sidb/presentation/features/pack_details/view/pack_action_bar.dart';
import 'package:sidb/presentation/features/pack_details/view/pack_question_card.dart';
import 'package:sidb/presentation/features/pack_details/view/pack_score_panel.dart';
import 'package:sidb/presentation/features/pack_details/view/pack_topic_sidebar.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class PackDetailsPage extends StatelessComponent {
  const PackDetailsPage({required this.id, super.key});

  final String id;

  @css
  static List<StyleRule> get styles => [
    css('.pd').styles(
      display: Display.flex,
      padding: Padding.symmetric(vertical: 2.5.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.rem),
    ),
    css('.pd-header').styles(
      display: Display.flex,
      padding: Padding.all(1.75.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusLg),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '6px 6px 0 0 var(--theme-border)'},
    ),
    css('.pd-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 2.25.rem,
      fontWeight: FontWeight.w900,
      lineHeight: 1.1.em,
    ),
    css('.pd-badges').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 10.px, column: 10.px),
    ),
    css('.pd-meta').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 6.px, column: 1.5.rem),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w700,
      textTransform: TextTransform.upperCase,
    ),
    css('.pd-authors').styles(
      margin: Margin.zero,
      color: AppTheme.textLinkColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w700,
    ),
    css('.pd-description').styles(
      padding: Padding.all(1.5.rem),
      margin: Margin.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.05.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
      backgroundColor: AppTheme.canvasColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
    ),
    css('.pd-layout').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.rem),
    ),
    css('.pd-main').styles(
      display: Display.flex,
      minWidth: 0.px,
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.rem),
      flex: Flex(grow: 1),
    ),
    css('.pd-topic').styles(
      padding: Padding.all(1.5.rem),
      raw: {'scroll-margin-top': '100px'},
    ),
    css('.pd-topic-header').styles(
      display: Display.flex,
      margin: Margin.only(bottom: 1.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.4.rem),
    ),
    css('.pd-topic-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.5.rem,
      fontWeight: FontWeight.w800,
      lineHeight: 1.2.em,
    ),
    css('.pd-topic-description').styles(
      margin: Margin.zero,
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
    ),
    css('.pd-questions').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
    ),
    css('.pd-state').styles(
      margin: Margin.symmetric(vertical: 4.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.1.rem,
      fontWeight: FontWeight.w700,
    ),
    css.media(MediaQuery.screen(minWidth: 1024.px), [
      css('.pd-layout').styles(
        flexDirection: FlexDirection.row,
        alignItems: AlignItems.start,
        gap: Gap.all(2.rem),
      ),
      css('.pd-sidebar').styles(width: 240.px),
    ]),
  ];

  @override
  Component build(BuildContext context) {
    return BlocProvider<PackDetailsBloc>(
      create: (context) => PackDetailsBloc(getIt<PackUseCase>())..add(LoadPackDetailsEvent(id)),
      child: const _PackDetailsView(),
    );
  }
}

class _PackDetailsView extends StatelessComponent {
  const _PackDetailsView();

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PackDetailsBloc, PackDetailsState>(
      builder: (context, state) => switch (state) {
        PackDetailsLoadingState() => _state(l10n.loadingPacks),
        PackDetailsErrorState(:final error) => _state('${l10n.packsLoadError}: $error'),
        PackDetailsNotFoundState() => const NotFoundPage(),
        PackDetailsLoadedState(:final pack) => _PackDetailsLoaded(pack: pack),
      },
    );
  }

  static Component _state(String text) => p(classes: 'pd-state', [.text(text)]);
}

class _PackDetailsLoaded extends StatefulComponent {
  const _PackDetailsLoaded({required this.pack});

  final DetailedPackage pack;

  @override
  State<_PackDetailsLoaded> createState() => _PackDetailsLoadedState();
}

class _PackDetailsLoadedState extends State<_PackDetailsLoaded> {
  bool _scoreOpen = false;

  void _toggleScoreboard() => setState(() => _scoreOpen = !_scoreOpen);
  void _closeScoreboard() => setState(() => _scoreOpen = false);

  @override
  Component build(BuildContext context) {
    final pack = component.pack;
    final l10n = context.l10n;
    return Component.fragment([
      div(classes: 'pd', [
        section(classes: 'pd-header', [
          h1(classes: 'pd-title', [.text(pack.title)]),
          div(classes: 'pd-badges', [
            NeoBadge(label: pack.gameType.label(l10n), tone: NeoBadgeTone.thematic),
            for (final audience in pack.audiences)
              NeoBadge(label: audience.label(l10n), tone: _tone(audience)),
          ]),
          div(classes: 'pd-meta', [
            span([.text(l10n.topicsCount(n: pack.topicsCount))]),
            span([.text('${l10n.added.toLowerCase()} · ${_shortDate(pack.publishDate)}')]),
          ]),
          if (pack.authors.isNotEmpty)
            p(
              classes: 'pd-authors',
              [.text(pack.authors.map((author) => author.name).join(' · '))],
            ),
        ]),
        PackActionBar(
          likesCount: pack.likesCount,
          dislikesCount: pack.dislikesCount,
          isScoreboardOpen: _scoreOpen,
          onToggleScoreboard: _toggleScoreboard,
        ),
        p(classes: 'pd-description', [.text(pack.description)]),
        div(classes: 'pd-layout', [
          PackTopicSidebar(topics: pack.topics),
          div(classes: 'pd-main', [
            for (final topic in pack.topics) _topic(topic),
          ]),
        ]),
      ]),
      PackScorePanel(isOpen: _scoreOpen, onClose: _closeScoreboard),
    ]);
  }

  Component _topic(Topic topic) {
    return NeoCard(
      classes: 'pd-topic',
      interactive: false,
      children: [
        div(classes: 'pd-topic-header', [
          h2(
            classes: 'pd-topic-title',
            attributes: {'id': 'topic-${topic.id}'},
            [.text(topic.title)],
          ),
          if (topic.description != null && topic.description!.isNotEmpty)
            p(classes: 'pd-topic-description', [.text(topic.description!)]),
        ]),
        if (topic.questions != null && topic.questions!.isNotEmpty)
          div(classes: 'pd-questions', [
            for (final question in topic.questions!)
              PackQuestionCard(question: question),
          ]),
      ],
    );
  }

  static NeoBadgeTone _tone(TargetAudience audience) => switch (audience) {
    TargetAudience.schooler => NeoBadgeTone.thematic,
    TargetAudience.student => NeoBadgeTone.student,
    TargetAudience.adult => NeoBadgeTone.hardcore,
  };

  static String _shortDate(DateTime date) {
    const months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
