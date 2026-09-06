import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_nav_link.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class FooterNeo extends StatelessComponent {
  const FooterNeo({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.footer').styles(
      display: Display.flex,
      padding: Padding.only(top: 1.75.rem, bottom: 1.5.rem),
      margin: Margin.only(top: 2.5.rem),
      border: Border.only(
        top: BorderSide.solid(width: NeoTokens.borderThick.px, color: AppTheme.borderColor),
      ),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.25.rem),
      flex: Flex(shrink: 0),
      color: AppTheme.theme.text,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      backgroundColor: AppTheme.theme.canvas,
    ),
    css('.footer-inner').styles(
      display: Display.flex,
      width: 100.percent,
      maxWidth: NeoTokens.pageMaxWidth.px,
      padding: Padding.symmetric(horizontal: 20.px),
      margin: Margin.symmetric(horizontal: Unit.auto),
      flexDirection: FlexDirection.column,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.25.rem),
    ),
    css('.footer-nav').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap(row: 0.5.rem, column: 0.5.rem),
    ),
    css('.footer-socials').styles(
      display: Display.flex,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
    css('.footer-social').styles(
      display: Display.inlineFlex,
      width: 40.px,
      height: 40.px,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.theme.text,
      textDecoration: TextDecoration.none,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.footer-social:hover').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.footer-social:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.footer-copyright-wrap').styles(
      padding: Padding.only(top: 1.rem),
      border: Border.only(
        top: BorderSide.solid(width: NeoTokens.borderThin.px, color: AppTheme.borderColor),
      ),
    ),
    css('.footer-copyright').styles(
      margin: Margin.zero,
      color: AppTheme.textSecondary,
      textAlign: TextAlign.center,
      fontSize: 13.px,
      fontWeight: FontWeight.w700,
    ),
    css.media(MediaQuery.screen(minWidth: 768.px), [
      css('.footer').styles(
        gap: Gap.all(1.5.rem),
      ),
      css('.footer-inner').styles(
        flexDirection: FlexDirection.row,
      ),
      css('.footer-nav').styles(
        justifyContent: JustifyContent.start,
      ),
      css('.footer-socials').styles(
        justifyContent: JustifyContent.end,
      ),
    ]),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return footer(classes: 'footer', [
      div(classes: 'footer-inner', [
        nav(classes: 'footer-nav', [
          NeoNavLink(label: l10n.aboutSite, to: '/about', square: true),
          NeoNavLink(label: l10n.faq, to: '/faq', square: true),
          NeoNavLink(label: l10n.contact, to: '/feedback', square: true),
          NeoNavLink(label: l10n.licensing, to: '/license', square: true),
          NeoNavLink(label: l10n.developerFaq, to: '/developer-faq', square: true),
        ]),
        div(classes: 'footer-socials', [
          a(
            href: 'https://t.me/',
            attributes: const {'aria-label': 'Telegram', 'target': '_blank', 'rel': 'noopener'},
            classes: 'footer-social',
            [
              const AppIcon(
                IconPaths.telegram,
                width: 22,
                height: 22,
                filled: true,
                fillColor: AppTheme.textLinkColor,
              ),
            ],
          ),
          a(
            href: 'mailto:hello@libsi.local',
            attributes: const {'aria-label': 'Email'},
            classes: 'footer-social',
            [
              const AppIcon(
                IconPaths.mail,
                width: 22,
                height: 22,
                strokeWidth: '2',
              ),
            ],
          ),
        ]),
      ]),
      div(classes: 'footer-copyright-wrap', [
        div(classes: 'footer-inner', [
          p(classes: 'footer-copyright', [.text(l10n.copyright)]),
        ]),
      ]),
    ]);
  }
}
