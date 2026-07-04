import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/input.dart';
import 'package:sidb/presentation/components/theme_toggle.dart';
import 'package:sidb/presentation/theme/app_theme.dart';

class TopBarNeo extends StatelessComponent {
  const TopBarNeo({required this.location, super.key});

  final String location;

  @css
  static List<StyleRule> get styles => [
    css('.topbar-icon-btn').styles(
      display: Display.inlineFlex,
      width: 36.px,
      height: 36.px,
      border: Border.all(width: 2.px, color: Colors.black),
      radius: BorderRadius.circular(2.px),
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: Transition('all', duration: 150.ms),
      transform: Transform.translate(x: 0.px, y: 0.px),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
    ),
    css('.topbar-icon-btn:hover').styles(
      shadow: BoxShadow(
        offsetX: 3.px,
        offsetY: 3.px,
        blur: 0.px,
        spread: 0.px,
        color: Colors.black,
      ),
    ),
    css('.topbar-route-btn').styles(
      display: Display.inlineFlex,
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: Transition('all', duration: 150.ms),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      fontFamily: const FontFamily('Geologica'),
      fontSize: 14.px,
      fontWeight: FontWeight.w500,
      textDecoration: TextDecoration.none,
    ),
    css('.topbar-route-btn-active').styles(
      height: 36.px,
      padding: Padding.symmetric(horizontal: 0.75.rem),
      border: Border.all(width: 2.px, color: Colors.black),
      radius: BorderRadius.circular(2.px),
      shadow: BoxShadow(
        offsetX: 6.px,
        offsetY: 6.px,
        blur: 0.px,
        spread: 0.px,
        color: Color('rgba(0,0,0,0.9)'),
      ),
      transform: Transform.translate(x: 0.px, y: 0.px),
      color: Colors.white,
      fontWeight: FontWeight.w700,
      backgroundColor: Color('#0077ff'),
    ),
    css('.topbar-route-btn-active:hover').styles(
      shadow: BoxShadow(
        offsetX: 3.px,
        offsetY: 3.px,
        blur: 0.px,
        spread: 0.px,
        color: Colors.black,
      ),
      transform: Transform.translate(x: 3.px, y: 3.px),
    ),
    css('.topbar-route-btn-inactive').styles(
      height: 36.px,
      padding: Padding.symmetric(horizontal: 0.75.rem),
      border: Border.all(width: 2.px, color: Colors.transparent),
      radius: BorderRadius.circular(2.px),
      color: Colors.black,
      fontWeight: FontWeight.w700,
      backgroundColor: Colors.transparent,
    ),
    css('.topbar-route-btn-inactive:hover').styles(
      border: Border.all(width: 2.px, color: Colors.black),
      shadow: BoxShadow(
        offsetX: 3.px,
        offsetY: 3.px,
        blur: 0.px,
        spread: 0.px,
        color: Colors.black,
      ),
      backgroundColor: Color('#ffde00'),
    ),
  ];

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

  @override
  Component build(BuildContext context) {
    const theme = AppTheme.theme;
    final l10n = context.l10n;
    final activePath = _normalizePath(location);

    return header(
      styles: Styles(
        display: Display.flex,
        position: Position.sticky(top: 0.px),
        zIndex: ZIndex(100),
        height: 84.px,
        padding: Padding.symmetric(horizontal: 9.5.rem),
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        gap: Gap.all(1.5.rem),
        backgroundColor: theme.surface,
        raw: {'box-shadow': '0 2px 0 0 #000000'},
      ),
      [
        nav(
          styles: Styles(
            display: Display.flex,
            alignItems: AlignItems.center,
            gap: Gap.all(2.5.rem),
          ),
          [
            TopBarItem(label: l10n.packages, to: '/', isActive: activePath == '/'),
            TopBarItem(label: l10n.search, to: '/search', isActive: activePath.startsWith('/search')),
            TopBarItem(label: l10n.authors, to: '/authors', isActive: activePath.startsWith('/authors')),
            TopBarItem(label: l10n.favorites, to: '/favorites', isActive: activePath.startsWith('/favorites')),
            TopBarItem(label: l10n.about, to: '/about', isActive: activePath.startsWith('/about')),
          ],
        ),
        div(
          styles: Styles(
            display: Display.flex,
            justifyContent: JustifyContent.end,
            alignItems: AlignItems.center,
            gap: Gap.all(1.5.rem),
            flex: Flex(grow: 1),
          ),
          [
            div(
              styles: Styles(
                position: Position.relative(),
                width: 400.px,
                maxWidth: 100.percent,
              ),
              [
                Input(
                  type: 'text',
                  placeholder: l10n.search_packages,
                  inlineStyles: Styles(
                    width: 100.percent,
                    height: 36.px,
                    padding: Padding.only(
                      left: 57.px,
                      right: 1.rem,
                      top: 0.px,
                      bottom: 0.px,
                    ),
                    border: Border.all(width: 2.px, color: theme.border),
                    radius: BorderRadius.circular(2.px),
                    transition: Transition('all', duration: 150.ms),
                    fontFamily: const FontFamily('Rubik'),
                    fontSize: 15.px,
                    fontWeight: FontWeight.w700,
                    backgroundColor: theme.surface,
                    raw: {'outline': 'none', 'box-shadow': 'none'},
                  ),
                ),
                span(
                  styles: Styles(
                    display: Display.flex,
                    position: Position.absolute(top: 50.percent, left: 30.px),
                    raw: {'transform': 'translateY(-50%)', 'pointer-events': 'none'},
                  ),
                  [
                    Icon(IconPaths.search, width: 18, height: 18, strokeWidth: '2'),
                  ],
                ),
              ],
            ),
            button(
              classes: 'topbar-icon-btn',
              styles: Styles(backgroundColor: Colors.white),
              [
                Icon(
                  _userPath,
                  width: 20,
                  height: 20,
                  filled: true,
                ),
              ],
            ),
            const ThemeToggle(),
          ],
        ),
      ],
    );
  }
}

const String _userPath =
    'M12 4a4 4 0 1 0 0 8 4 4 0 0 0 0-8zm0 10c-5.33 0-8 2.67-8 4v1h16v-1c0-1.33-2.67-4-8-4z';

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
      styles: Styles(textDecoration: TextDecoration.none, raw: {'color': 'inherit'}),
      child: span(
        classes: 'topbar-route-btn ${isActive ? 'topbar-route-btn-active' : 'topbar-route-btn-inactive'}',
        [.text(label)],
      ),
    );
  }
}
