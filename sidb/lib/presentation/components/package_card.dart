import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_badge.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class PackageCard extends StatelessComponent {
  final Pack pack;

  const PackageCard({super.key, required this.pack});

  @css
  static List<StyleRule> get styles => [
    css('.pc').styles(
      width: 100.percent,
      minWidth: 240.px,
      minHeight: 300.px,
      maxWidth: 300.px,
    ),
    css('.pc-title').styles(
      overflow: Overflow.hidden,
      color: AppTheme.theme.text,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 18.px,
      fontWeight: FontWeight.w700,
      textTransform: TextTransform.capitalize,
      lineHeight: 1.15.em,
      raw: {
        'display': '-webkit-box',
        '-webkit-line-clamp': '2',
        '-webkit-box-orient': 'vertical',
        'white-space': 'pre-line',
      },
    ),
    css('.pc-badges').styles(
      display: Display.flex,
      margin: Margin.only(top: 10.px),
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.start,
      alignItems: AlignItems.start,
      gap: Gap(row: 8.px, column: 8.px),
    ),
    css('.pc-badge').styles(
      maxWidth: 100.percent,
      padding: Padding.symmetric(horizontal: 9.px),
      flex: Flex(shrink: 1),
      raw: {
        'overflow-wrap': 'anywhere',
        'white-space': 'normal',
      },
    ),
    css('.pc-meta').styles(
      display: Display.flex,
      margin: Margin.only(top: 20.px),
      flexDirection: FlexDirection.column,
      color: AppTheme.theme.text,
      fontFamily: const FontFamily('Inter'),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
      lineHeight: 1.2.em,
    ),
    css('.pc-added').styles(
      margin: Margin.only(top: 4.px),
      color: AppTheme.theme.textSec,
      fontFamily: const FontFamily('Inter'),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
    ),
    css('.pc-authors').styles(
      margin: Margin.only(top: 8.px),
      overflow: Overflow.hidden,
      flex: Flex(grow: 1),
      color: AppTheme.theme.textLink,
      textAlign: TextAlign.justify,
      fontFamily: const FontFamily('Inter'),
      fontSize: 12.px,
      fontWeight: FontWeight.w700,
      lineHeight: 1.em,
      raw: {
        'display': '-webkit-box',
        '-webkit-line-clamp': '7',
        '-webkit-box-orient': 'vertical',
      },
    ),
    css('.pc-reactions').styles(
      display: Display.flex,
      margin: Margin.only(top: 8.px),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
    ),
    css('.pc-reactions-group').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(20.px),
    ),
    css('.pc-reaction-btn').styles(
      padding: Padding.zero,
      gap: Gap.all(6.px),
      color: AppTheme.theme.text,
      fontSize: 20.px,
      fontWeight: FontWeight.w400,
      lineHeight: 1.em,
      raw: {'box-shadow': 'none'},
    ),
    css('.pc-bookmark-btn').styles(
      padding: Padding.zero,
      color: AppTheme.theme.text,
      raw: {'box-shadow': 'none'},
    ),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;

    return NeoCard(
      classes: 'pc',
      children: [
        h3(classes: 'pc-title', [.text(pack.title)]),
        div(classes: 'pc-badges', [
          NeoBadge(label: pack.gameType, tone: NeoBadgeTone.thematic, classes: 'pc-badge'),
          NeoBadge(label: pack.difficultyType, tone: NeoBadgeTone.student, classes: 'pc-badge'),
          NeoBadge(label: pack.difficulty, tone: NeoBadgeTone.general, classes: 'pc-badge'),
        ]),
        div(classes: 'pc-meta', [
          span([.text(l10n.topicsCount(n: pack.topicsCount).toLowerCase())]),
          span([.text(_monthYear(pack.publishDate))]),
        ]),
        p(classes: 'pc-added', [.text(l10n.addedYesterday)]),
        p(classes: 'pc-authors', [.text(pack.authors.map((author) => author.name).join(' · '))]),
        div(classes: 'pc-reactions', [
          div(classes: 'pc-reactions-group', [
            NeoButton(
              variant: NeoButtonVariant.ghost,
              classes: 'pc-reaction-btn',
              children: [
                AppIcon(
                  IconPaths.thumbUp,
                  width: 22,
                  height: 22,
                  filled: true,
                  fillColor: AppTheme.theme.textLink,
                ),
                span([.text('${pack.likesCount}')]),
              ],
            ),
            NeoButton(
              variant: NeoButtonVariant.ghost,
              classes: 'pc-reaction-btn',
              children: [
                AppIcon(
                  IconPaths.thumbDown,
                  width: 22,
                  height: 22,
                  filled: true,
                  fillColor: AppTheme.theme.textLink,
                ),
                span([.text('${pack.dislikesCount}')]),
              ],
            ),
          ]),
          NeoButton(
            variant: NeoButtonVariant.ghost,
            classes: 'pc-bookmark-btn',
            children: [
              AppIcon(
                IconPaths.bookmark,
                width: 18,
                height: 22,
                filled: true,
                fillColor: AppTheme.theme.textLink,
              ),
            ],
          ),
        ]),
      ],
    );
  }

  static String _monthYear(DateTime date) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
