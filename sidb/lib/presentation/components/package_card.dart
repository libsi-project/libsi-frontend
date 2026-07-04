import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/features/pack/model/pack.dart';
import 'package:sidb/presentation/theme/app_theme.dart';

class PackageCard extends StatelessComponent {
  final Pack pack;

  const PackageCard({super.key, required this.pack});

  static const _cyanBadge = Color('#a6feff');
  static const _greenBadge = Color('#c3ffc7');
  static const _yellowBadge = Color('#fff9a9');

  @css
  static List<StyleRule> get styles => [
    css('.pc').styles(
      display: Display.flex,
      width: 100.percent,
      minWidth: 240.px,
      minHeight: 300.px,
      maxWidth: 300.px,
      padding: Padding.all(1.rem),
      border: Border.all(width: 3.px, color: AppTheme.theme.border),
      radius: BorderRadius.circular(6.px),
      shadow: BoxShadow(
        offsetX: 6.px,
        offsetY: 6.px,
        blur: 0.px,
        spread: 0.px,
        color: AppTheme.theme.border,
      ),
      transition: Transition('all', duration: 150.ms),
      flexDirection: FlexDirection.column,
      backgroundColor: AppTheme.theme.surface,
    ),
    css('.pc:hover').styles(
      shadow: BoxShadow(
        offsetX: 4.px,
        offsetY: 4.px,
        blur: 0.px,
        spread: 0.px,
        color: AppTheme.theme.border,
      ),
      transform: Transform.translate(x: 6.px, y: 6.px),
    ),
    css('.pc-title').styles(
      overflow: Overflow.hidden,
      color: AppTheme.theme.text,
      fontFamily: const FontFamily('Geologica'),
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
      flexWrap: FlexWrap.nowrap,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
    ),
    css('.pc-badge').styles(
      display: Display.inlineFlex,
      height: 27.px,
      padding: Padding.symmetric(horizontal: 7.px),
      border: Border.all(width: 2.px, color: AppTheme.theme.border),
      radius: BorderRadius.circular(3.px),
      shadow: BoxShadow(
        offsetX: 4.px,
        offsetY: 4.px,
        blur: 0.px,
        spread: 0.px,
        color: AppTheme.theme.border,
      ),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: Colors.black,
      fontFamily: const FontFamily('Inter'),
      fontSize: 11.px,
      fontWeight: FontWeight.w700,
      whiteSpace: WhiteSpace.noWrap,
      raw: {'letter-spacing': '-0.1px'},
    ),
    css('.pc-badge-cyan').styles(backgroundColor: _cyanBadge),
    css('.pc-badge-green').styles(backgroundColor: _greenBadge),
    css('.pc-badge-yellow').styles(backgroundColor: _yellowBadge),
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
      display: Display.inlineFlex,
      padding: Padding.zero,
      border: Border.unset,
      cursor: Cursor.pointer,
      alignItems: AlignItems.center,
      gap: Gap.all(6.px),
      color: AppTheme.theme.text,
      fontFamily: const FontFamily('Inter'),
      fontSize: 20.px,
      fontWeight: FontWeight.w400,
      lineHeight: 1.em,
      backgroundColor: Colors.transparent,
    ),
    css('.pc-bookmark-btn').styles(
      display: Display.inlineFlex,
      padding: Padding.zero,
      border: Border.unset,
      cursor: Cursor.pointer,
      color: AppTheme.theme.text,
      backgroundColor: Colors.transparent,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;

    return div(classes: 'pc', [
      h3(classes: 'pc-title', [.text(pack.title)]),
      div(classes: 'pc-badges', [
        span(classes: 'pc-badge pc-badge-cyan', [.text(pack.gameType)]),
        span(classes: 'pc-badge pc-badge-green', [.text(pack.difficultyType)]),
        span(classes: 'pc-badge pc-badge-yellow', [.text(pack.difficulty)]),
      ]),
      div(classes: 'pc-meta', [
        span([.text(l10n.topicsCount(n: pack.topicsCount).toLowerCase())]),
        span([.text(_monthYear(pack.publishDate))]),
      ]),
      p(classes: 'pc-added', [.text(l10n.addedYesterday)]),
      p(classes: 'pc-authors', [.text(pack.authors.join(' · '))]),
      div(classes: 'pc-reactions', [
        div(classes: 'pc-reactions-group', [
          button(classes: 'pc-reaction-btn', [
            Icon(
              IconPaths.thumbUp,
              width: 22,
              height: 22,
              filled: true,
              fillColor: AppTheme.theme.textLink,
            ),
            span([.text('${pack.likesCount}')]),
          ]),
          button(classes: 'pc-reaction-btn', [
            Icon(
              _thumbDownPath,
              width: 22,
              height: 22,
              filled: true,
              fillColor: AppTheme.theme.textLink,
            ),
            span([.text('${pack.dislikesCount}')]),
          ]),
        ]),
        button(classes: 'pc-bookmark-btn', [
          Icon(
            _bookmarkPath,
            width: 18,
            height: 22,
            filled: true,
            fillColor: AppTheme.theme.textLink,
          ),
        ]),
      ]),
    ]);
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

  static const String _thumbDownPath =
      'M10 14H5.236a2 2 0 01-1.789-2.894l3.5-7A2 2 0 018.737 3h4.017c.163 0 .326.02.485.06L17 4m-7 10v5a2 2 0 002 2h.095c.5 0 .905-.405.905-.905 0-.714.211-1.412.608-2.006L17 13V4m-7 10h2m5-10h2a2 2 0 012 2v6a2 2 0 01-2 2h-2.5';
  static const String _bookmarkPath = 'M6 4h12a1 1 0 011 1v16l-7-4-7 4V5a1 1 0 011-1z';
}
