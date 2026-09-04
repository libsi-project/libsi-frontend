import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/neo_drawer.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/theme_toggle.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class TopBarNeo extends StatelessComponent {
  const TopBarNeo({
    required this.location,
    this.initialSearchQuery,
    super.key,
  });

  final String location;
  final String? initialSearchQuery;

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

  static String _searchLocation(String query) =>
      query.isEmpty ? '/search' : Uri(path: '/search', queryParameters: {'q': query}).toString();

  @css
  static List<StyleRule> get stylesheets => [
    css('.top-bar-neo').styles(
      display: Display.flex,
      position: Position.sticky(top: 0.px),
      zIndex: ZIndex(100),
      padding: Padding.symmetric(horizontal: 20.px, vertical: 20.px),
      margin: Margin.symmetric(horizontal: (-20).px),
      border: Border.only(
        bottom: BorderSide.solid(width: 1.px, color: AppTheme.borderColor),
      ),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
      flex: Flex(shrink: 0),
      backgroundColor: AppTheme.canvasColor,
      raw: {'box-shadow': 'none'},
    ),
    css('.top-bar-neo-nav').styles(
      display: Display.none,
      alignItems: AlignItems.center,
      gap: Gap.all(20.px),
    ),
    css('.top-bar-neo-actions').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
      flex: Flex(grow: 1),
    ),
    css('.top-bar-neo-search').styles(
      position: Position.relative(),
      width: 100.percent,
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
    css('.top-bar-burger').styles(
      display: Display.inlineFlex,
      width: 36.px,
      height: 36.px,
      padding: Padding.zero,
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      appearance: Appearance.none,
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      cursor: Cursor.pointer,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'outline': 'none',
        'line-height': '0',
      },
    ),
    css('.top-bar-burger:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.top-bar-burger:active').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)'},
    ),
    css('.top-bar-burger:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.top-bar-burger-icon').styles(
      display: Display.block,
      raw: {'shape-rendering': 'crispEdges'},
    ),
    css('.top-bar-drawer-link').styles(
      display: Display.block,
      padding: Padding.symmetric(horizontal: 12.px, vertical: 10.px),
      border: Border.all(style: BorderStyle.solid, width: 3.px, color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.1.rem,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      raw: {'outline': 'none'},
    ),
    css('.top-bar-drawer-link:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.top-bar-drawer-link-active').styles(
      border: NeoTokens.border(width: NeoTokens.borderThick),
      backgroundColor: AppTheme.accentColor,
    ),
    css.media(MediaQuery.screen(minWidth: 768.px), [
      css('.top-bar-neo').styles(
        padding: Padding.symmetric(horizontal: 0.px, vertical: 20.px),
        margin: Margin.zero,
        border: Border.only(
          bottom: BorderSide.solid(width: NeoTokens.borderThin.px, color: AppTheme.borderColor),
        ),
        raw: {'box-shadow': '0 2px 0 0 var(--theme-border)'},
      ),
      css('.top-bar-neo-nav').styles(display: Display.flex),
      css('.top-bar-burger').styles(display: Display.none),
      css('.top-bar-neo-actions').styles(
        justifyContent: JustifyContent.end,
      ),
      css('.top-bar-neo-search').styles(
        maxWidth: 380.px,
        flex: Flex(grow: 0),
      ),
    ]),
  ];

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final activePath = _normalizePath(location);
    final items = _items(context, activePath);

    return header(
      classes: 'top-bar-neo',
      [
        _TopBarDrawerButton(
          location: location,
          items: items,
          openLabel: l10n.openMenu,
          title: l10n.menu,
          closeLabel: l10n.closeMenu,
        ),
        nav(
          classes: 'top-bar-neo-nav',
          [
            for (final item in items) _TopBarNavLink(label: item.label, to: item.to, isActive: item.isActive),
          ],
        ),
        div(
          classes: 'top-bar-neo-actions',
          [
            div(
              classes: 'top-bar-neo-search',
              [
                SearchField(
                  placeholder: l10n.searchPackages,
                  initialValue: initialSearchQuery,
                  searchLabel: l10n.search,
                  onSubmit: (query) => router.Router.of(context).push(_searchLocation(query)),
                ),
              ],
            ),
            const ThemeToggle(),
          ],
        ),
      ],
    );
  }

  List<_NavItem> _items(BuildContext context, String activePath) {
    final l10n = context.l10n;
    final searchTarget = _searchLocation((initialSearchQuery ?? '').trim());
    return [
      _NavItem(label: l10n.packages, to: '/', isActive: activePath == '/'),
      _NavItem(label: l10n.search, to: searchTarget, isActive: activePath.startsWith('/search')),
      _NavItem(label: l10n.authors, to: '/authors', isActive: activePath.startsWith('/authors')),
      _NavItem(label: l10n.about, to: '/about', isActive: activePath.startsWith('/about')),
      _NavItem(
        label: l10n.developerFaqNav,
        to: '/developer-faq',
        isActive: activePath.startsWith('/developer-faq'),
      ),
    ];
  }
}

class _TopBarDrawerButton extends StatefulComponent {
  const _TopBarDrawerButton({
    required this.location,
    required this.items,
    required this.openLabel,
    required this.title,
    required this.closeLabel,
  });

  final String location;
  final List<_NavItem> items;
  final String openLabel;
  final String title;
  final String closeLabel;

  @override
  State<_TopBarDrawerButton> createState() => _TopBarDrawerButtonState();
}

class _TopBarDrawerButtonState extends State<_TopBarDrawerButton> {
  bool _drawerOpen = false;

  @override
  void didUpdateComponent(covariant _TopBarDrawerButton oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (_drawerOpen && oldComponent.location != component.location) {
      _drawerOpen = false;
    }
  }

  void _openDrawer() => setState(() => _drawerOpen = true);
  void _closeDrawer() => setState(() => _drawerOpen = false);

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      button(
        classes: 'top-bar-burger',
        type: ButtonType.button,
        attributes: {
          'aria-label': component.openLabel,
          'aria-expanded': _drawerOpen ? 'true' : 'false',
        },
        onClick: _openDrawer,
        [
          svg(
            classes: 'top-bar-burger-icon',
            viewBox: '0 0 18 14',
            width: 18.px,
            height: 14.px,
            attributes: const {'aria-hidden': 'true', 'focusable': 'false'},
            [
              rect(
                x: '0',
                y: '0',
                width: '18',
                height: '2',
                fill: AppTheme.textColor,
                [],
              ),
              rect(
                x: '0',
                y: '6',
                width: '18',
                height: '2',
                fill: AppTheme.textColor,
                [],
              ),
              rect(
                x: '0',
                y: '12',
                width: '18',
                height: '2',
                fill: AppTheme.textColor,
                [],
              ),
            ],
          ),
        ],
      ),
      NeoDrawer(
        isOpen: _drawerOpen,
        onClose: _closeDrawer,
        title: component.title,
        closeLabel: component.closeLabel,
        children: [
          for (final item in component.items)
            router.Link(
              to: item.to,
              classes: [
                'top-bar-drawer-link',
                if (item.isActive) 'top-bar-drawer-link-active',
              ].join(' '),
              child: Component.text(item.label),
            ),
        ],
      ),
    ]);
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.to, required this.isActive});
  final String label;
  final String to;
  final bool isActive;
}

class _TopBarNavLink extends StatelessComponent {
  const _TopBarNavLink({
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
