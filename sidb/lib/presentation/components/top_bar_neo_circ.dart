import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/neo_nav_link.dart';

import 'package:sidb/presentation/components/theme_toggle.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

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
    final activePath = _normalizePath(location);
    final l10n = context.l10n;
    final headerStyle = Styles(
      display: Display.flex,
      position: Position.sticky(top: 1.25.rem),
      zIndex: ZIndex(100),
      height: 72.px,
      minHeight: 72.px,
      padding: Padding.symmetric(horizontal: NeoTokens.pagePaddingX.rem),
      margin: Margin.only(top: 1.25.rem, left: NeoTokens.pagePaddingX.rem, right: NeoTokens.pagePaddingX.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick, color: theme.border),
      radius: NeoTokens.radius(NeoTokens.radiusLg),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowLg, color: theme.border),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.5.rem),
      flex: Flex(shrink: 0),
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
                TopBarItem(
                  label: l10n.developerFaqNav,
                  to: '/developer-faq',
                  isActive: activePath.startsWith('/developer-faq'),
                ),
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
                SearchField(
                  placeholder: l10n.searchPackages,
                  inputStyles: Styles(
                    radius: NeoTokens.radius(NeoTokens.radiusPill),
                    transition: NeoTokens.transition(NeoTokens.motionSlowMs),
                    fontWeight: FontWeight.w700,
                    backgroundColor: theme.inputBg,
                  ),
                ),
              ],
            ),
            const NeoIconButton(
              variant: NeoButtonVariant.user,
              child: AppIcon(
                IconPaths.users,
                strokeWidth: '2.5',
              ),
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
    return NeoNavLink(label: label, to: to, isActive: isActive);
  }
}
