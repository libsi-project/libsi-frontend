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
      padding: Padding.only(
        left: NeoTokens.pagePaddingX.rem,
        right: NeoTokens.pagePaddingX.rem,
        top: 2.5.rem,
        bottom: 2.rem,
      ),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.5.rem),
      flex: Flex(shrink: 0),
      color: AppTheme.theme.text,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      backgroundColor: AppTheme.theme.canvas,
    ),
    css('.footer-nav').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
    css('.footer-socials').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
    ),
    css('.footer-social').styles(
      display: Display.inlineFlex,
      cursor: Cursor.pointer,
      color: AppTheme.theme.text,
      backgroundColor: Colors.transparent,
    ),
    css('.footer-copyright').styles(
      color: AppTheme.theme.text,
      fontSize: 14.px,
      fontWeight: FontWeight.w700,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return footer(classes: 'footer', [
      nav(classes: 'footer-nav', [
        NeoNavLink(label: l10n.aboutSite, to: '/about'),
        NeoNavLink(label: l10n.faq, to: '/faq'),
        NeoNavLink(label: l10n.contact, to: '/feedback'),
        NeoNavLink(label: l10n.licensing, to: '/license'),
        NeoNavLink(label: l10n.developerFaq, to: '/developer-faq'),
      ]),
      div(classes: 'footer-socials', [
        a(
          href: 'https://t.me/',
          attributes: const {'aria-label': 'Telegram', 'target': '_blank', 'rel': 'noopener'},
          classes: 'footer-social',
          [
            const AppIcon(
              IconPaths.telegram,
              width: 24,
              height: 24,
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
              width: 26,
              height: 24,
              strokeWidth: '2',
            ),
          ],
        ),
      ]),
      p(classes: 'footer-copyright', [
        .text(l10n.copyright),
      ]),
    ]);
  }
}
