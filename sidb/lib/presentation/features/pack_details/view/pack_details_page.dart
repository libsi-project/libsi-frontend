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
import 'package:sidb/presentation/features/pack/model/question/question.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';
import 'package:sidb/presentation/features/pack/model/topic/topic.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';
import 'package:sidb/presentation/features/pack_details/bloc/pack_details_bloc.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class PackDetailsPage extends StatelessComponent {
  const PackDetailsPage({required this.id, super.key});

  final String id;

  @css
  static List<StyleRule> get styles => [
    css('.pd').styles(
      display: Display.flex,
      padding: Padding.symmetric(vertical: 2.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.5.rem),
    ),
    css('.pd-header').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
    ),
    css('.pd-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 2.rem,
      fontWeight: FontWeight.w800,
      lineHeight: 1.15.em,
    ),
    css('.pd-badges').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 8.px, column: 8.px),
    ),
    css('.pd-meta').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap(row: 4.px, column: 20.px),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w700,
    ),
    css('.pd-authors').styles(
      color: AppTheme.textLinkColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w700,
    ),
    css('.pd-description').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
    ),
    css('.pd-topics').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.25.rem),
    ),
    css('.pd-topic-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.35.rem,
      fontWeight: FontWeight.w800,
    ),
    css('.pd-topic-description').styles(
      margin: Margin.only(top: 6.px),
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.4.em,
    ),
    css('.pd-questions').styles(
      display: Display.flex,
      margin: Margin.only(top: 12.px),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
    ),
    css('.pd-question').styles(
      display: Display.flex,
      padding: Padding.all(1.rem),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.start,
      gap: Gap.all(0.75.rem),
      backgroundColor: AppTheme.canvasColor,
    ),
    css('.pd-question-points').styles(
      display: Display.inlineFlex,
      minWidth: 40.px,
      padding: Padding.symmetric(horizontal: 8.px, vertical: 4.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.pd-question-text').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.4.em,
    ),
    css('.pd-state').styles(
      margin: Margin.symmetric(vertical: 3.rem),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.1.rem,
      fontWeight: FontWeight.w700,
    ),
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
        PackDetailsLoadedState(:final pack) => _content(context, pack),
      },
    );
  }

  Component _content(BuildContext context, DetailedPackage pack) {
    final l10n = context.l10n;
    return div(classes: 'pd', [
      div(classes: 'pd-header', [
        h1(classes: 'pd-title', [.text(pack.title)]),
        div(classes: 'pd-badges', [
          NeoBadge(label: pack.gameType.label(l10n), tone: NeoBadgeTone.thematic),
          for (final audience in pack.audiences)
            NeoBadge(label: audience.label(l10n), tone: _tone(audience)),
        ]),
        div(classes: 'pd-meta', [
          span([.text(l10n.topicsCount(n: pack.topicsCount).toLowerCase())]),
          span([.text('${l10n.added}: ${_shortDate(pack.publishDate)}')]),
        ]),
        if (pack.authors.isNotEmpty)
          p(
            classes: 'pd-authors',
            [.text(pack.authors.map((author) => author.name).join(' · '))],
          ),
      ]),
      p(classes: 'pd-description', [.text(pack.description)]),
      div(
        classes: 'pd-topics',
        [for (final topic in pack.topics) _topic(topic)],
      ),
    ]);
  }

  Component _topic(Topic topic) {
    return NeoCard(interactive: false, children: [
      h2(classes: 'pd-topic-title', [.text(topic.title)]),
      if (topic.description != null && topic.description!.isNotEmpty)
        p(classes: 'pd-topic-description', [.text(topic.description!)]),
      if (topic.questions != null && topic.questions!.isNotEmpty)
        div(
          classes: 'pd-questions',
          [for (final question in topic.questions!) _question(question)],
        ),
    ]);
  }

  Component _question(Question question) {
    // Question points aren't in the model yet — derive from the mock
    // id (mock uses `topicIndex * 100 + questionIndex`, so `id % 100`
    // maps back to a 0-based question position). This keeps Phase 1
    // simple; Phase 2 will introduce a real `points` field with the
    // accordion for the answer.
    final position = question.id % 100;
    final points = (position + 1) * 10;
    return div(classes: 'pd-question', [
      span(classes: 'pd-question-points', [.text('$points')]),
      p(classes: 'pd-question-text', [.text(question.text)]),
    ]);
  }

  static Component _state(String text) => p(classes: 'pd-state', [.text(text)]);

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
