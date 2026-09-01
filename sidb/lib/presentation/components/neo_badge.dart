import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

enum NeoBadgeTone { student, hardcore, thematic, general, neutral }

class NeoBadge extends StatelessComponent {
  const NeoBadge({
    required this.label,
    this.tone = NeoBadgeTone.neutral,
    this.classes,
    this.styles,
    super.key,
  });

  final String label;
  final NeoBadgeTone tone;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-badge').styles(
      display: Display.inlineFlex,
      minHeight: 27.px,
      padding: Padding.symmetric(horizontal: 7.px),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      shadow: NeoTokens.shadow(offset: NeoTokens.shadowMd),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 11.px,
      fontWeight: FontWeight.w700,
      whiteSpace: WhiteSpace.noWrap,
      raw: {'letter-spacing': '-0.1px'},
    ),
  ];

  @override
  Component build(BuildContext context) {
    return span(
      classes: ['neo-badge', ?classes].join(' '),
      styles: Styles(backgroundColor: _toneColor(tone)).combine(styles ?? Styles()),
      [.text(label)],
    );
  }

  static Color _toneColor(NeoBadgeTone tone) {
    return switch (tone) {
      NeoBadgeTone.student => AppTheme.badgeStudentColor,
      NeoBadgeTone.hardcore => AppTheme.badgeHardcoreColor,
      NeoBadgeTone.thematic => AppTheme.badgeThematicColor,
      NeoBadgeTone.general => AppTheme.badgeGeneralColor,
      NeoBadgeTone.neutral => AppTheme.badgeNeutralColor,
    };
  }
}
