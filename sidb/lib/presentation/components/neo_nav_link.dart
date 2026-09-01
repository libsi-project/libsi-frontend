import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class NeoNavLink extends StatelessComponent {
  const NeoNavLink({
    required this.label,
    required this.to,
    this.isActive = false,
    this.square = false,
    this.classes,
    super.key,
  });

  final String label;
  final String to;
  final bool isActive;
  final bool square;
  final String? classes;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-nav-link').styles(
      display: Display.inlineFlex,
      cursor: Cursor.pointer,
      userSelect: UserSelect.none,
      transition: NeoTokens.transition(),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 14.px,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      raw: {'outline': 'none'},
    ),
    css('.neo-nav-link:hover').styles(
      border: NeoTokens.border(),
      backgroundColor: AppTheme.accentColor,
    ),
    css('.neo-nav-link:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.neo-nav-link-active').styles(
      border: NeoTokens.border(),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowSm),
      color: AppTheme.onPrimaryColor,
      fontWeight: FontWeight.w900,
      backgroundColor: AppTheme.primaryColor,
      raw: {
        'background-image': 'radial-gradient(rgba(255, 255, 255, 0.3) 1px, transparent 0)',
        'background-size': '4px 4px',
      },
    ),
    css('.neo-nav-link-active:hover').styles(
      color: AppTheme.onAccentColor,
      backgroundColor: AppTheme.accentColor,
    ),
    css('.neo-nav-link-inactive').styles(
      border: NeoTokens.border(color: Colors.transparent),
      color: AppTheme.textColor,
      backgroundColor: Colors.transparent,
    ),
    css('.neo-nav-link-inactive:hover').styles(
      border: NeoTokens.border(),
      backgroundColor: AppTheme.accentColor,
    ),
  ];

  @override
  Component build(BuildContext context) {
    return router.Link(
      to: to,
      styles: Styles(textDecoration: TextDecoration.none, raw: {'color': 'inherit'}),
      child: span(
        classes: [
          'neo-nav-link',
          if (isActive) 'neo-nav-link-active',
          if (!isActive) 'neo-nav-link-inactive',
          ?classes,
        ].join(' '),
        styles: Styles(
          padding: Padding.symmetric(
            horizontal: isActive ? 1.25.rem : 0.75.rem,
            vertical: isActive ? 0.6.rem : 0.4.rem,
          ),
          radius: NeoTokens.radius(square ? NeoTokens.radiusSm : NeoTokens.radiusPill),
        ),
        [.text(label)],
      ),
    );
  }
}
