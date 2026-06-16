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

  static String _normalizePath(String rawLocation) {
    // jaspr_router may include hash fragments depending on deployment configuration.
    // Normalize to a plain path like "/about".
    var s = rawLocation.trim();

    // Convert "/#/about" or "#/about" to "/about"
    if (s.startsWith('/#')) s = s.substring(2);
    if (s.startsWith('#')) s = s.substring(1);

    // Drop querystring + fragment
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

    final headerStyle = Styles(
      display: Display.flex,
      position: Position.sticky(top: 0.px),
      zIndex: ZIndex(10),
      height: 64.px,
      padding: Padding.symmetric(horizontal: 1.5.rem),
      border: Border.only(
        bottom: BorderSide.solid(width: 3.px, color: theme.border),
      ),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.5.rem),
      backgroundColor: theme.surface,
    );

    final leftSectionStyle = Styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(1.5.rem),
      flex: Flex(shrink: 0),
    );

    final navStyle = Styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
    );

    final rightSectionStyle = Styles(
      display: Display.flex,
      justifyContent: JustifyContent.end,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
      flex: Flex(grow: 1),
    );

    return header(
      styles: headerStyle,
      [
        div(
          styles: leftSectionStyle,
          [
            nav(
              styles: navStyle,
              [
                TopBarItem(label: l10n.packages, to: '/', isActive: activePath == '/'),
                TopBarItem(label: l10n.search, to: '/search', isActive: activePath.startsWith('/search')),
                TopBarItem(label: l10n.authors, to: '/authors', isActive: activePath.startsWith('/authors')),
                TopBarItem(label: l10n.favorites, to: '/favorites', isActive: activePath.startsWith('/favorites')),
                TopBarItem(label: l10n.about, to: '/about', isActive: activePath.startsWith('/about')),
              ],
            ),
          ],
        ),
        div(
          styles: rightSectionStyle,
          [
            div(
              styles: Styles(
                position: Position.relative(),
                width: 480.px,
                maxWidth: 100.percent,
              ),
              [
                Input(
                  type: 'text',
                  placeholder: l10n.search_packages,
                  inlineStyles: Styles(
                    width: 100.percent,
                    padding: Padding.only(
                      left: 2.75.rem,
                      right: 1.rem,
                      top: 0.6.rem,
                      bottom: 0.6.rem,
                    ),
                    border: Border.all(width: 2.px, color: theme.border),
                    radius: BorderRadius.circular(6.px),
                    transition: Transition('all', duration: 200.ms),
                    fontWeight: FontWeight.w700,
                    backgroundColor: theme.inputBg,
                    raw: {'outline': 'none'},
                  ),
                ),
              ],
            ),
            button(
              classes: 'topbar-icon-btn',
              styles: Styles(backgroundColor: theme.userBtn),
              [
                span([
                  Icon(
                    IconPaths.users,
                    classes: 'h-6 w-6',
                    strokeWidth: '2.5',
                  ),
                ]),
              ],
            ),
            const ThemeToggle(),
          ],
        ),
      ],
    );
  }
}

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
    const theme = AppTheme.theme;

    return router.Link(
      to: to,
      styles: Styles(textDecoration: TextDecoration.none, raw: {'color': 'inherit'}),
      child: span(
        classes: 'topbar-route-btn ${isActive ? 'topbar-route-btn-active' : 'topbar-route-btn-inactive'}',
        styles: isActive
            ? Styles(
                border: Border.all(width: 2.px, color: theme.border),
                shadow: BoxShadow(
                  offsetX: 4.px,
                  offsetY: 4.px,
                  color: theme.border,
                ),
                backgroundColor: theme.primary,
              )
            : Styles(
                color: theme.text,
                raw: {
                  'background-color': 'transparent',
                },
              ),
        [.text(label)],
      ),
    );
  }
}
