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
        minHeight: 84.px,
        padding: Padding.symmetric(horizontal: 9.5.rem),
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        gap: Gap.all(1.5.rem),
        flex: Flex(shrink: 0),
        backgroundColor: theme.surface,
        raw: {'box-shadow': '0 2px 0 0 var(--theme-border)'},
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
            TopBarItem(
              label: l10n.developerFaqNav,
              to: '/developer-faq',
              isActive: activePath.startsWith('/developer-faq'),
            ),
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
                SearchField(
                  placeholder: l10n.searchPackages,
                  iconStyles: Styles(
                    position: Position.absolute(top: 50.percent, left: 30.px),
                  ),
                  inputStyles: Styles(
                    height: 36.px,
                    padding: Padding.only(
                      left: 57.px,
                      right: 1.rem,
                      top: 0.px,
                      bottom: 0.px,
                    ),
                    border: NeoTokens.border(color: theme.border),
                    radius: NeoTokens.radius(NeoTokens.radiusSm),
                    transition: NeoTokens.transition(),
                    fontFamily: const FontFamily('Rubik'),
                    fontSize: 15.px,
                    fontWeight: FontWeight.w700,
                    backgroundColor: theme.surface,
                    raw: {'box-shadow': 'none'},
                  ),
                ),
              ],
            ),
            const NeoIconButton(
              variant: NeoButtonVariant.surface,
              shape: NeoIconButtonShape.square,
              size: 36,
              child: AppIcon(
                _userPath,
                width: 20,
                height: 20,
                filled: true,
              ),
            ),
            const ThemeToggle(),
          ],
        ),
      ],
    );
  }
}

const String _userPath = 'M12 4a4 4 0 1 0 0 8 4 4 0 0 0 0-8zm0 10c-5.33 0-8 2.67-8 4v1h16v-1c0-1.33-2.67-4-8-4z';

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
    return NeoNavLink(label: label, to: to, isActive: isActive, square: true);
  }
}
