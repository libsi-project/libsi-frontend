import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/components/page_container.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class NotFoundPage extends StatelessComponent {
  const NotFoundPage({
    super.key,
  });

  @css
  static List<StyleRule> get styles => [
    css('.not-found').styles(
      display: Display.flex,
      minHeight: 70.vh,
      padding: Padding.symmetric(vertical: 3.rem),
      flexDirection: FlexDirection.column,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(1.5.rem),
    ),
    css('.not-found-hero').styles(
      display: Display.flex,
      position: Position.relative(),
      padding: Padding.symmetric(horizontal: 1.5.rem, vertical: 1.25.rem),
      border: NeoTokens.border(width: NeoTokens.borderStrong),
      radius: NeoTokens.radius(NeoTokens.radiusLg),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowLg, color: AppTheme.errorColor),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'background-image': 'radial-gradient(rgba(0, 0, 0, 0.12) 1.4px, transparent 0)',
        'background-size': '8px 8px',
      },
    ),
    css('.not-found-code').styles(
      position: Position.relative(),
      color: AppTheme.primaryColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 7.rem,
      fontWeight: FontWeight.w900,
      lineHeight: 0.85.em,
      raw: {
        'letter-spacing': '-0.06em',
        'text-shadow': '6px 6px 0 var(--theme-accent), 12px 12px 0 var(--theme-border)',
      },
    ),
    css('.not-found-stamp').styles(
      display: Display.inlineFlex,
      position: Position.absolute(top: (-0.85).rem, right: (-0.65).rem),
      padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.35.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      transform: Transform.rotate((-11).deg),
      color: AppTheme.onPrimaryColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.75.rem,
      fontWeight: FontWeight.w900,
      whiteSpace: WhiteSpace.noWrap,
      backgroundColor: AppTheme.errorColor,
      raw: {'letter-spacing': '0.12em'},
    ),
    css('.not-found-copy').styles(
      display: Display.flex,
      maxWidth: 34.rem,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
      textAlign: TextAlign.center,
    ),
    css('.not-found-heading').styles(
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 2.rem,
      fontWeight: FontWeight.w900,
      lineHeight: 1.15.em,
    ),
    css('.not-found-message').styles(
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.05.rem,
      fontWeight: FontWeight.w700,
      lineHeight: 1.45.em,
    ),
    css('.not-found-path').styles(
      display: Display.inlineFlex,
      maxWidth: 100.percent,
      padding: Padding.symmetric(horizontal: 0.85.rem, vertical: 0.45.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      overflow: Overflow.hidden,
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowXs),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.85.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.accentColor,
      raw: {'text-overflow': 'ellipsis', 'white-space': 'nowrap'},
    ),
    css('.not-found-actions').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
    css.media(MediaQuery.screen(maxWidth: 640.px), [
      css('.not-found-code').styles(
        fontSize: 4.5.rem,
        raw: {
          'text-shadow': '4px 4px 0 var(--theme-accent), 8px 8px 0 var(--theme-border)',
        },
      ),
      css('.not-found-heading').styles(
        fontSize: 1.6.rem,
      ),
    ]),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;

    return PageContainer(children: [
      section(
        classes: 'not-found',
        attributes: const {'aria-labelledby': 'not-found-heading'},
        [
          div(classes: 'not-found-hero', [
          span(
            classes: 'not-found-stamp',
            [.text(l10n.notFoundBadge)],
          ),
          span(
            classes: 'not-found-code',
            attributes: const {'aria-hidden': 'true'},
            [.text('404')],
          ),
        ]),
        div(classes: 'not-found-copy', [
          h1(
            id: 'not-found-heading',
            classes: 'not-found-heading',
            [.text(l10n.notFoundHeading)],
          ),
          p(classes: 'not-found-message', [.text(l10n.notFoundMessage)]),
        ]),
        div(classes: 'not-found-actions', [
          NeoButton(
            variant: NeoButtonVariant.primary,
            size: NeoButtonSize.lg,
            styles: Styles(
              radius: NeoTokens.radius(NeoTokens.radiusNone),
            ),
            onClick: () => router.Router.of(context).replace('/'),
            children: [
              const AppIcon(
                IconPaths.package,
                width: 20,
                height: 20,
                strokeColor: AppTheme.onPrimaryColor,
              ),
              .text(l10n.notFoundGoHome),
            ],
          ),
          NeoButton(
            variant: NeoButtonVariant.accent,
            size: NeoButtonSize.lg,
            styles: Styles(
              radius: NeoTokens.radius(NeoTokens.radiusNone),
            ),
            onClick: () => router.Router.of(context).replace('/search'),
            children: [
              const AppIcon(
                IconPaths.search,
                width: 18,
                height: 18,
              ),
              .text(l10n.notFoundGoSearch),
            ],
          ),
        ]),
        ],
      ),
    ]);
  }
}
