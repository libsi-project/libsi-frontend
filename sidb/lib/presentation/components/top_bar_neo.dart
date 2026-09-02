import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_drawer.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/theme_toggle.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class TopBarNeo extends StatefulComponent {
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
      gap: Gap.all(1.rem),
      flex: Flex(shrink: 0),
      backgroundColor: const Color('color-mix(in srgb, var(--theme-canvas) 90%, transparent)'),
      raw: {'-webkit-backdrop-filter': 'blur(5px)'},
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
      width: 40.px,
      height: 40.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.top-bar-burger:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.top-bar-burger:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
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
  State<TopBarNeo> createState() => _TopBarNeoState();
}

class _TopBarNeoState extends State<TopBarNeo> {
  bool _drawerOpen = false;
  late String _query = component.initialSearchQuery ?? '';

  @override
  void didUpdateComponent(covariant TopBarNeo oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (_drawerOpen && oldComponent.location != component.location) {
      _drawerOpen = false;
    }
    // Keep the input synced with the URL when a search is actually
    // active. Leaving /search must not reset what the user typed, so
    // we only overwrite when the incoming query is non-null.
    final incoming = component.initialSearchQuery;
    if (incoming != null && incoming != oldComponent.initialSearchQuery && incoming != _query) {
      _query = incoming;
    }
  }

  void _openDrawer() => setState(() => _drawerOpen = true);
  void _closeDrawer() => setState(() => _drawerOpen = false);

  void _onQueryChange(String value) {
    if (value == _query) return;
    setState(() => _query = value);
  }

  void _submitSearch(BuildContext context) {
    _closeDrawer();
    final trimmed = _query.trim();
    router.Router.of(context).push(_searchLocation(trimmed));
  }

  static String _searchLocation(String query) => query.isEmpty
      ? '/search'
      : Uri(path: '/search', queryParameters: {'q': query}).toString();

  List<_NavItem> _items(BuildContext context, String activePath) {
    final l10n = context.l10n;
    final searchTarget = _searchLocation(_query.trim());
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

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final activePath = TopBarNeo._normalizePath(component.location);
    final items = _items(context, activePath);

    return Component.fragment([
      header(
        classes: 'top-bar-neo',
        [
          button(
            classes: 'top-bar-burger',
            type: ButtonType.button,
            attributes: {
              'aria-label': l10n.openMenu,
              'aria-expanded': _drawerOpen ? 'true' : 'false',
            },
            onClick: _openDrawer,
            [
              const AppIcon(
                IconPaths.menu,
                width: 22,
                height: 22,
                strokeWidth: '3',
              ),
            ],
          ),
          nav(
            classes: 'top-bar-neo-nav',
            [
              for (final item in items)
                _TopBarNavLink(label: item.label, to: item.to, isActive: item.isActive),
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
                    value: _query,
                    searchLabel: l10n.search,
                    onChange: _onQueryChange,
                    onSubmit: (_) => _submitSearch(context),
                  ),
                ],
              ),
              const ThemeToggle(),
            ],
          ),
        ],
      ),
      NeoDrawer(
        isOpen: _drawerOpen,
        onClose: _closeDrawer,
        title: l10n.menu,
        closeLabel: l10n.closeMenu,
        children: [
          for (final item in items)
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
