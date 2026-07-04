import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/theme/app_theme.dart';

class FooterNeo extends StatelessComponent {
  const FooterNeo({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.footer').styles(
      display: Display.flex,
      padding: Padding.only(
        left: 9.5.rem,
        right: 9.5.rem,
        top: 2.5.rem,
        bottom: 2.rem,
      ),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.5.rem),
      color: Colors.black,
      fontFamily: const FontFamily('Inter'),
      backgroundColor: AppTheme.theme.canvas,
    ),
    css('.footer-nav').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      alignItems: AlignItems.center,
      gap: Gap.all(3.rem),
    ),
    css('.footer-link').styles(
      cursor: Cursor.pointer,
      color: Colors.black,
      fontSize: 14.px,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
    ),
    css('.footer-link:hover').styles(
      textDecoration: const TextDecoration(line: TextDecorationLine.underline),
    ),
    css('.footer-socials').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
    ),
    css('.footer-social').styles(
      display: Display.inlineFlex,
      cursor: Cursor.pointer,
      color: Colors.black,
      backgroundColor: Colors.transparent,
    ),
    css('.footer-copyright').styles(
      color: Colors.black,
      fontSize: 14.px,
      fontWeight: FontWeight.w700,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return footer(classes: 'footer', [
      nav(classes: 'footer-nav', [
        a(href: '/about', classes: 'footer-link', [.text(l10n.aboutSite)]),
        a(href: '/faq', classes: 'footer-link', [.text(l10n.faq)]),
        a(href: '/feedback', classes: 'footer-link', [.text(l10n.contact)]),
        a(href: '/license', classes: 'footer-link', [.text(l10n.licensing)]),
      ]),
      div(classes: 'footer-socials', [
        a(
          href: 'https://t.me/',
          attributes: const {'aria-label': 'Telegram', 'target': '_blank', 'rel': 'noopener'},
          classes: 'footer-social',
          [_telegramIcon()],
        ),
        a(
          href: 'mailto:hello@libsi.local',
          attributes: const {'aria-label': 'Email'},
          classes: 'footer-social',
          [_envelopeIcon()],
        ),
      ]),
      p(classes: 'footer-copyright', [
        .text(l10n.copyright),
      ]),
    ]);
  }

  static Component _telegramIcon() {
    return svg(
      attributes: const {
        'width': '24',
        'height': '24',
        'viewBox': '0 0 24 24',
        'fill': 'none',
        'xmlns': 'http://www.w3.org/2000/svg',
      },
      [
        circle(attributes: const {'cx': '12', 'cy': '12', 'r': '12', 'fill': 'black'}, []),
        path(
          attributes: const {
            'fill': 'white',
            'd':
                'M17.89 7.15c.2-.86-.42-1.24-1.01-1.02L5.2 10.66c-.79.31-.78.76-.13.96l2.98.93 6.92-4.36c.33-.22.63-.1.38.13l-5.6 5.06-.22 3.1c.31 0 .45-.14.61-.3l1.46-1.41 3.03 2.24c.56.31.96.15 1.1-.51l1.99-9.35z',
          },
          [],
        ),
      ],
    );
  }

  static Component _envelopeIcon() {
    return svg(
      attributes: const {
        'width': '26',
        'height': '24',
        'viewBox': '0 0 26 24',
        'fill': 'none',
        'xmlns': 'http://www.w3.org/2000/svg',
      },
      [
        rect(
          attributes: const {
            'x': '2',
            'y': '4.5',
            'width': '22',
            'height': '15',
            'rx': '1',
            'stroke': 'black',
            'stroke-width': '2',
            'fill': 'none',
          },
          [],
        ),
        path(
          attributes: const {
            'd': 'M3 7l10 6.5L23 7',
            'stroke': 'black',
            'stroke-width': '2',
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'fill': 'none',
          },
          [],
        ),
      ],
    );
  }
}
