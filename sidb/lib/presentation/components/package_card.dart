import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/core/extensions/date_time.dart';
import 'package:sidb/presentation/features/pack/model/pack.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/components/icon.dart';

class PackageCard extends StatelessComponent {
  final Pack pack;

  const PackageCard({
    super.key,
    required this.pack,
  });

  @css
  static List<StyleRule> get styles => [
    css.fontFace(
      family: 'Geologica',
      url: 'fonts/Geologica.ttf',
      style: FontStyle.normal,
    ),
    css(
      '.package-card',
      [
        css('&').styles(
          display: Display.flex,
          width: 100.percent,
          minWidth: 240.px,
          minHeight: 300.px,
          maxWidth: 300.px,
          border: Border.all(width: 3.px, color: AppTheme.theme.border),
          radius: BorderRadius.circular(6.px),
          shadow: BoxShadow(
            offsetX: 6.px,
            offsetY: 6.px,
            blur: 0.px,
            spread: 0.px,
            color: AppTheme.theme.border,
          ),
          transition: Transition('all', duration: 200.ms),
          flexDirection: FlexDirection.column,
          backgroundColor: AppTheme.theme.surface,
        ),
        css('&:hover').styles(
          shadow: BoxShadow(
            offsetX: 2.px,
            offsetY: 2.px,
            blur: 0.px,
            spread: 0.px,
            color: AppTheme.theme.border,
          ),
          transform: Transform.translate(x: 4.px, y: 4.px),
        ),
      ],
    ),
    css('.badge').styles(
      display: Display.inlineFlex,
      padding: Padding.symmetric(horizontal: 0.6.rem, vertical: 0.25.rem),
      border: Border.all(width: 2.px, color: AppTheme.theme.border),
      radius: BorderRadius.circular(4.px),
      alignItems: AlignItems.center,
      color: AppTheme.theme.border,
      fontSize: 0.75.rem,
      fontWeight: FontWeight.w700,
      textTransform: TextTransform.upperCase,
      whiteSpace: WhiteSpace.noWrap,
    ),
    css('.badge-student').styles(backgroundColor: AppTheme.theme.badgeStudent),
    css('.badge-hardcore').styles(backgroundColor: AppTheme.theme.badgeHardcore),
    css('.badge-thematic').styles(backgroundColor: AppTheme.theme.badgeThematic),
    css('.badge-general').styles(backgroundColor: AppTheme.theme.badgeGeneral),
  ];

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'package-card',
      [
        // Card content
        div(
          styles: Styles(
            padding: Padding.all(1.rem),
            flex: Flex(grow: 1),
          ),
          [
            // Title
            h3(
              styles: Styles(
                margin: Margin.only(bottom: 0.6.rem),
                color: AppTheme.theme.text,
                fontFamily: FontFamily('Geologica'),
                fontSize: 1.15.rem,
                fontWeight: FontWeight.w800,
                textTransform: TextTransform.upperCase,
                lineHeight: 1.2.em,
              ),
              [Component.text(pack.title)],
            ),

            // Badges row
            div(
              styles: Styles(
                display: Display.flex,
                margin: Margin.only(bottom: 0.75.rem),
                flexWrap: FlexWrap.wrap,
                gap: Gap.all(0.5.rem),
              ),
              [
                span(
                  classes: 'badge badge-${_badgeClassByDifficulty(pack.difficultyType)}',
                  [Component.text(pack.difficultyType)],
                ),
                span(
                  classes: 'badge',
                  styles: Styles(backgroundColor: AppTheme.theme.badgeNeutral),
                  [Component.text(pack.gameType)],
                ),
                span(
                  classes: 'badge',
                  styles: Styles(backgroundColor: AppTheme.theme.accent),
                  [Component.text(pack.difficulty)],
                ),
              ],
            ),

            // Meta info
            div(
              styles: Styles(
                display: Display.flex,
                margin: Margin.only(bottom: 0.6.rem),
                flexDirection: FlexDirection.column,
                gap: Gap.all(0.25.rem),
              ),
              [
                p(
                  styles: Styles(
                    color: AppTheme.theme.textSec,
                    fontSize: 0.9.rem,
                    fontWeight: FontWeight.w700,
                  ),
                  [Component.text(context.l10n.topics_count(n: pack.topicsCount))],
                ),
                p(
                  styles: Styles(
                    color: AppTheme.theme.textSec,
                    fontSize: 0.9.rem,
                    fontWeight: FontWeight.w700,
                  ),
                  [Component.text('Добавлен ${pack.publishDate.printable}')],
                ),
              ],
            ),

            // Authors section
            p(
              styles: Styles(
                color: AppTheme.theme.text,
                fontSize: 0.95.rem,
                fontWeight: FontWeight.w700,
                lineHeight: 1.35.em,
              ),
              [Component.text(pack.authors.join(' · '))],
            ),
          ],
        ),

        // Footer
        div(
          styles: Styles(
            display: Display.flex,
            padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.75.rem),
            border: Border.only(
              top: BorderSide(width: 2.px, color: AppTheme.theme.border),
            ),
            justifyContent: JustifyContent.spaceBetween,
            alignItems: AlignItems.center,
            color: AppTheme.theme.text,
            fontSize: 0.9.rem,
            fontWeight: FontWeight.w700,
            backgroundColor: AppTheme.theme.surface,
          ),
          [
            div(
              styles: Styles(
                display: Display.flex,
                alignItems: AlignItems.center,
                gap: Gap.all(0.75.rem),
              ),
              [
                // Like button
                button(
                  styles: Styles(
                    display: Display.flex,
                    border: Border.unset,
                    cursor: Cursor.pointer,
                    alignItems: AlignItems.center,
                    gap: Gap.all(0.25.rem),
                    color: AppTheme.theme.text,
                    backgroundColor: Colors.transparent,
                  ),
                  [
                    Icon(
                      IconPaths.thumbUp,
                      classes: '',
                      width: 18,
                      height: 18,
                      strokeWidth: '2.5',
                    ),
                    span([Component.text('${pack.likesCount}')]),
                  ],
                ),

                // Download or dislike button
                if (pack.dislikesCount > 0)
                  button(
                    styles: Styles(
                      display: Display.flex,
                      border: Border.unset,
                      cursor: Cursor.pointer,
                      alignItems: AlignItems.center,
                      gap: Gap.all(0.25.rem),
                      color: AppTheme.theme.text,
                      backgroundColor: Colors.transparent,
                    ),
                    [
                      Icon(
                        IconPaths.thumbUp,
                        classes: '',
                        width: 18,
                        height: 18,
                        strokeWidth: '2.5',
                      ),
                      span([Component.text('${pack.dislikesCount}')]),
                    ],
                  )
                else
                  button(
                    styles: Styles(
                      display: Display.flex,
                      border: Border.unset,
                      cursor: Cursor.pointer,
                      color: AppTheme.theme.text,
                      backgroundColor: Colors.transparent,
                    ),
                    [
                      Icon(
                        _bookmarkPath,
                        classes: '',
                        width: 18,
                        height: 18,
                        strokeWidth: '2.5',
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _badgeClassByDifficulty(String difficultyType) {
    final normalized = difficultyType.trim().toLowerCase();
    if (normalized.contains('student')) return 'student';
    if (normalized.contains('hard')) return 'hardcore';
    if (normalized.contains('theme')) return 'thematic';
    return 'general';
  }

  static const String _bookmarkPath = 'M6 4h12a2 2 0 012 2v14l-8-4-8 4V6a2 2 0 012-2z';
}
