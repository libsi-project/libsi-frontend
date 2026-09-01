import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/theme_toggle.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class TopBarNeo extends StatelessComponent {
  const TopBarNeo({required this.location, super.key});

  final String location;

  static String _normalizePath(String rawLocation) {
    var s = rawLocation.trim();
    if (s.startsWith('/#')) s = s.substring(2);
    if (s.startsWith('#')) s = s.substring(1);
    final q = s.indexOf('?');
    if (q != -1) s = s.substring(0, q);
    final h = s.indexOf('#');
    if (h != -1) s = s.substring(0, h);
    if (s.isEmpty) return '/';
    if (!s.startsWith('/')) s = '/$s';
    if (s.length > 1 && s.endsWith('/')) s = s.substring(0, s.length - 1);
    return s;
  }

  @css
  static List<StyleRule> get stylesheets => [
    css('.top-bar-neo').styles(
      display: Display.flex,
      position: Position.sticky(top: 0.px),
      zIndex: ZIndex(100),
      padding: Padding.symmetric(vertical: 20.px),
      border: Border.only(
        bottom: BorderSide.dashed(width: 3.px, color: AppTheme.borderColor),
      ),
      backdropFilter: Filter.blur(5.px),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.5.rem),
      flex: Flex(shrink: 0),
      backgroundColor: const Color('color-mix(in srgb, var(--theme-canvas) 90%, transparent)'),
      raw: {'-webkit-backdrop-filter': 'blur(5px)'},
    ),
    css('.top-bar-neo-nav').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(20.px),
    ),
    css('.top-bar-neo-actions').styles(
      display: Display.flex,
      justifyContent: JustifyContent.end,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
      flex: Flex(grow: 1),
    ),
    css('.top-bar-nav-link').styles(
      padding: Padding.symmetric(horizontal: 10.px, vertical: 5.px),
      border: Border.all(style: BorderStyle.solid, width: 3.px, color: Colors.transparent),
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: Transition('all', duration: 300.ms),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.2.rem,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      raw: {'outline': 'none'},
    ),
    css('.top-bar-nav-link:hover').styles(
      transform: Transform.combine([
        Transform.translate(y: (-5).px),
        Transform.rotate((-2).deg),
      ]),
      backgroundColor: AppTheme.accentColor,
      raw: {'border-bottom-color': 'var(--theme-border)'},
    ),
    css('.top-bar-nav-link:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.top-bar-nav-link-active').styles(
      backgroundColor: AppTheme.accentColor,
      raw: {'border-bottom-color': 'var(--theme-border)'},
    ),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final activePath = _normalizePath(location);

    return header(
      classes: 'top-bar-neo',
      [
        nav(
          classes: 'top-bar-neo-nav',
          [
            TopBarItem(label: l10n.packages, to: '/', isActive: activePath == '/'),
            TopBarItem(label: l10n.search, to: '/search', isActive: activePath.startsWith('/search')),
            TopBarItem(label: l10n.authors, to: '/authors', isActive: activePath.startsWith('/authors')),
            TopBarItem(label: l10n.about, to: '/about', isActive: activePath.startsWith('/about')),
            TopBarItem(
              label: l10n.developerFaqNav,
              to: '/developer-faq',
              isActive: activePath.startsWith('/developer-faq'),
            ),
          ],
        ),
        div(
          classes: 'top-bar-neo-actions',
          [
            div(
              styles: Styles(
                position: Position.relative(),
                width: 380.px,
                maxWidth: 100.percent,
              ),
              [
                SearchField(placeholder: l10n.searchPackages),
              ],
            ),
            //TODO: uncomment when user is implemented
            // const NeoIconButton(
            //   variant: NeoButtonVariant.surface,
            //   shape: NeoIconButtonShape.square,
            //   size: 36,
            //   child: AppIcon(
            //     _userPath,
            //     width: 20,
            //     height: 20,
            //     filled: true,
            //   ),
            // ),
            const ThemeToggle(),
          ],
        ),
      ],
    );
  }
}
//TODO: uncomment when user is implemented
// const NeoIconButton(
//const String _userPath = 'M12 4a4 4 0 1 0 0 8 4 4 0 0 0 0-8zm0 10c-5.33 0-8 2.67-8 4v1h16v-1c0-1.33-2.67-4-8-4z';

class TopBarItem extends StatelessComponent {
  const TopBarItem({
    required this.label,
    required this.to,
    this.isActive = false,
  });

  final String label;
  final String to;
  final bool isActive;

  @override
  Component build(BuildContext context) {
    return router.Link(
      to: to,
      classes: [
        'top-bar-nav-link',
        if (isActive) 'top-bar-nav-link-active',
      ].join(' '),
      child: Component.text(label),
    );
  }
}
