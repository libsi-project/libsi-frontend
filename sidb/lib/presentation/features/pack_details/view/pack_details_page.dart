import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:universal_web/web.dart' as web;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/core/di/di.dart';
import 'package:sidb/presentation/components/app_dialog.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_badge.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/components/neo_toast.dart';
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
import 'package:sidb/presentation/features/pack_details/view/pack_scoreboard_scope.dart';
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
      width: 100.percent,
      maxWidth: 1600.px,
      padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 2.5.rem),
      margin: Margin.symmetric(horizontal: Unit.auto),
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.rem),
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
    css('.pd-header').styles(
      display: Display.flex,
      padding: Padding.all(1.75.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
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
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.05.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
      backgroundColor: AppTheme.canvasColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
    ),
    css('.pd-topic').styles(
      padding: Padding.all(1.5.rem),
    ),
    css('.pd-topic-header').styles(
      display: Display.flex,
      margin: Margin.only(bottom: 1.rem),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.4.rem),
    ),
    css('.pd-topic-title-row').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
    ),
    css('.pd-topic-actions').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(10.px),
      flex: Flex(shrink: 0),
    ),
    css('.pd-topic-action').styles(
      display: Display.inlineFlex,
      width: 44.px,
      height: 44.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-topic-action:hover').styles(
      transform: Transform.translate(x: 2.px, y: 2.px),
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.pd-topic-action:active').styles(
      transform: Transform.translate(x: 4.px, y: 4.px),
      raw: {'box-shadow': '0 0 0 0 var(--theme-border)'},
    ),
    css('.pd-topic-action:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-topic-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.5.rem,
      fontWeight: FontWeight.w800,
      lineHeight: 1.2.em,
      raw: {'scroll-margin-top': '100px'},
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
      css('.pd').styles(
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 2.5.rem),
      ),
      css('.pd-layout').styles(
        display: Display.grid,
        alignItems: AlignItems.start,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize(220.px)),
            GridTrack(TrackSize.minmax(TrackSize(0.px), .fr(1))),
            GridTrack(TrackSize(260.px)),
          ]),
        ),
        gap: Gap.all(2.rem),
      ),
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
        PackDetailsLoadedState(:final pack) => ScoreboardHost(child: _PackDetailsLoaded(pack: pack)),
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
  @override
  void initState() {
    super.initState();
    // If the user landed here via a deep link like `/pack/1#topic-3`,
    // the browser can't jump to the anchor because Jaspr hydrates the
    // DOM after load. Do the scroll manually once the tree is mounted.
    Timer.run(_scrollToHash);
  }

  void _scrollToHash() {
    if (!mounted) return;
    final hash = web.window.location.hash;
    if (hash.length < 2) return;
    final id = hash.substring(1);
    final element = web.document.getElementById(id);
    element?.scrollIntoView(
      web.ScrollIntoViewOptions(behavior: 'smooth', block: 'start'),
    );
  }

  void _copyTopicLink(BuildContext context, int topicId) {
    final l10n = context.l10n;
    final origin = web.window.location.origin;
    final basePath = context.binding.basePath;
    final normalised = basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final target = '$origin$normalised/pack/${component.pack.id}#topic-$topicId';
    final toast = ToastScope.of(context);
    try {
      // TODO: once we can pull in `dart:js_interop` without breaking
      // Jaspr's CSS-generation phase, await this JS promise and
      // surface the actual success/failure instead of relying on
      // synchronous exceptions.
      web.window.navigator.clipboard.writeText(target);
      toast.show(l10n.topicLinkCopied);
    } catch (_) {
      toast.show(l10n.topicLinkCopyFailed);
    }
  }

  Future<void> _promptLogin(BuildContext context) {
    final l10n = context.l10n;
    return context.showDialog(
      title: l10n.loginRequiredTitle,
      message: l10n.loginRequiredMessage,
      cancelLabel: l10n.loginLater,
      okLabel: l10n.loginNow,
      onCancel: () {},
      onOk: () {
        // TODO: once /login lands, `router.Router.of(context).push('/login')`.
      },
    );
  }

  @override
  Component build(BuildContext context) {
    final pack = component.pack;
    final l10n = context.l10n;
    return div(classes: 'pd', [
      div(classes: 'pd-layout', [
        PackTopicSidebar(topics: pack.topics),
        div(classes: 'pd-main', [
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
          ),
          p(classes: 'pd-description', [.text(pack.description)]),
          for (final topic in pack.topics) _topic(context, topic),
        ]),
        const PackScorePanel(),
      ]),
    ]);
  }

  Component _topic(BuildContext context, Topic topic) {
    final l10n = context.l10n;
    return NeoCard(
      classes: 'pd-topic',
      interactive: false,
      styles: Styles(radius: NeoTokens.radius(NeoTokens.radiusNone)),
      children: [
        div(classes: 'pd-topic-header', [
          div(classes: 'pd-topic-title-row', [
            h2(
              classes: 'pd-topic-title',
              attributes: {'id': 'topic-${topic.id}'},
              [.text(topic.title)],
            ),
            div(classes: 'pd-topic-actions', [
              button(
                classes: 'pd-topic-action',
                type: ButtonType.button,
                attributes: {'aria-label': l10n.topicShare, 'title': l10n.topicShare},
                onClick: () => _copyTopicLink(context, topic.id),
                [
                  const AppIcon(IconPaths.link, width: 20, height: 20, strokeWidth: '2.5'),
                ],
              ),
              button(
                classes: 'pd-topic-action',
                type: ButtonType.button,
                attributes: {'aria-label': l10n.topicBookmark, 'title': l10n.topicBookmark},
                onClick: () => _promptLogin(context),
                [
                  const AppIcon(IconPaths.bookmark, width: 18, height: 20, strokeWidth: '2.5'),
                ],
              ),
            ]),
          ]),
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
