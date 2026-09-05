import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/app_dialog.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Row of pack-level actions rendered under the header.
class PackActionBar extends StatelessComponent {
  const PackActionBar({
    required this.likesCount,
    required this.dislikesCount,
    required this.isScoreboardOpen,
    required this.onToggleScoreboard,
    super.key,
  });

  final int likesCount;
  final int dislikesCount;
  final bool isScoreboardOpen;
  final VoidCallback onToggleScoreboard;

  @css
  static List<StyleRule> get styles => [
    css('.pd-action-bar').styles(
      display: Display.flex,
      padding: Padding.all(1.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      flexWrap: FlexWrap.wrap,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '6px 6px 0 0 var(--theme-border)'},
    ),
    css('.pd-action-spacer').styles(
      flex: Flex(grow: 1),
    ),
    css('.pd-action-btn .neo-button-icon').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      color: const Color('inherit'),
    ),
  ];

  Future<void> _promptLogin(BuildContext context) {
    final l10n = context.l10n;
    return context.showDialog(
      title: l10n.loginRequiredTitle,
      message: l10n.loginRequiredMessage,
      cancelLabel: l10n.loginLater,
      okLabel: l10n.loginNow,
      onCancel: () {},
      onOk: () {
        // TODO: once /login lands, `router.Router.of(context).push('/login')`.
      },
    );
  }

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return div(
      classes: 'pd-action-bar',
      attributes: const {'role': 'group'},
      [
        NeoButton(
          variant: NeoButtonVariant.surface,
          size: NeoButtonSize.md,
          onClick: () => _promptLogin(context),
          classes: 'pd-action-btn',
          children: [
            span(classes: 'neo-button-icon', [
              const AppIcon(
                IconPaths.thumbUp,
                width: 18,
                height: 18,
                filled: true,
                fillColor: AppTheme.textLinkColor,
              ),
            ]),
            span([.text('${l10n.packLike} · $likesCount')]),
          ],
        ),
        NeoButton(
          variant: NeoButtonVariant.surface,
          size: NeoButtonSize.md,
          onClick: () => _promptLogin(context),
          classes: 'pd-action-btn',
          children: [
            span(classes: 'neo-button-icon', [
              const AppIcon(
                IconPaths.thumbDown,
                width: 18,
                height: 18,
                filled: true,
                fillColor: AppTheme.textLinkColor,
              ),
            ]),
            span([.text('${l10n.packDislike} · $dislikesCount')]),
          ],
        ),
        NeoButton(
          variant: NeoButtonVariant.surface,
          size: NeoButtonSize.md,
          onClick: () => _promptLogin(context),
          classes: 'pd-action-btn',
          children: [
            span(classes: 'neo-button-icon', [
              const AppIcon(
                IconPaths.bookmark,
                width: 18,
                height: 18,
                filled: true,
                fillColor: AppTheme.textLinkColor,
              ),
            ]),
            span([.text(l10n.packBookmark)]),
          ],
        ),
        div(classes: 'pd-action-spacer', []),
        NeoButton(
          variant: isScoreboardOpen ? NeoButtonVariant.accent : NeoButtonVariant.primary,
          size: NeoButtonSize.md,
          onClick: onToggleScoreboard,
          classes: 'pd-action-btn',
          attributes: {'aria-pressed': isScoreboardOpen ? 'true' : 'false'},
          children: [
            span([.text(isScoreboardOpen ? l10n.packCloseScoreboard : l10n.packOpenScoreboard)]),
          ],
        ),
      ],
    );
  }
}
