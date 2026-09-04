import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Off-canvas slide-in drawer with a backdrop.
///
/// Controlled: [isOpen] and [onClose] are owned by the parent. Escape
/// closes the drawer while it has focus; backdrop click and the close
/// button also invoke [onClose].
class NeoDrawer extends StatelessComponent {
  const NeoDrawer({
    required this.isOpen,
    required this.onClose,
    this.title,
    this.children = const [],
    this.closeLabel = 'Close',
    super.key,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final String? title;
  final List<Component> children;
  final String closeLabel;

  static const double _panelWidth = 300;

  @css
  static List<StyleRule> get stylesheets => [
    css('.neo-drawer').styles(
      display: Display.block,
      position: Position.fixed(top: 0.px, right: 0.px, bottom: 0.px, left: 0.px),
      zIndex: ZIndex(1000),
      overflow: Overflow.hidden,
      pointerEvents: PointerEvents.none,
    ),
    css('.neo-drawer-open').styles(
      pointerEvents: PointerEvents.auto,
    ),
    css('.neo-drawer-backdrop').styles(
      position: Position.absolute(top: 0.px, right: 0.px, bottom: 0.px, left: 0.px),
      opacity: 0,
      transition: Transition('opacity', duration: NeoTokens.motionSlowMs.ms),
      backgroundColor: const Color('rgba(0, 0, 0, 0.45)'),
    ),
    css('.neo-drawer-open .neo-drawer-backdrop').styles(opacity: 1),
    css('.neo-drawer-panel').styles(
      display: Display.flex,
      position: Position.absolute(top: 0.px, left: 0.px),
      width: _panelWidth.px,
      height: 100.percent,
      maxWidth: 85.percent,
      border: Border.only(
        right: BorderSide.solid(width: NeoTokens.borderThin.px, color: AppTheme.borderColor),
      ),
      transition: Transition('transform', duration: NeoTokens.motionSlowMs.ms),
      transform: Transform.translate(x: (-100).percent),
      flexDirection: FlexDirection.column,
      backgroundColor: AppTheme.canvasColor,
      raw: {'box-shadow': 'none'},
    ),
    css('.neo-drawer-open .neo-drawer-panel').styles(
      transform: Transform.translate(x: 0.percent),
    ),
    css('.neo-drawer-header').styles(
      display: Display.flex,
      minHeight: 36.px,
      padding: Padding.symmetric(horizontal: 20.px, vertical: 20.px),
      border: Border.only(
        bottom: BorderSide.solid(width: 1.px, color: AppTheme.borderColor),
      ),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
      flex: Flex(shrink: 0),
      raw: {'box-shadow': 'none'},
    ),
    css('.neo-drawer-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.25.rem,
      fontWeight: FontWeight.w800,
    ),
    css('.neo-drawer-close').styles(
      display: Display.inlineFlex,
      width: 36.px,
      height: 36.px,
      padding: Padding.zero,
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': 'none', 'outline': 'none'},
    ),
    css('.neo-drawer-close:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.neo-drawer-close:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.neo-drawer-body').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 20.px, vertical: 1.25.rem),
      overflow: Overflow.only(y: Overflow.auto),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.5.rem),
    ),
  ];

  void _onBackdropClick(web.Event event) {
    event.stopPropagation();
    onClose();
  }

  void _onKeyDown(web.Event event) {
    if (!isOpen) return;
    final key = (event as web.KeyboardEvent).key;
    if (key == 'Escape') {
      event.preventDefault();
      onClose();
    }
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: [
        'neo-drawer',
        if (isOpen) 'neo-drawer-open',
      ].join(' '),
      attributes: {
        'aria-hidden': isOpen ? 'false' : 'true',
        // `inert` while closed removes the panel from tab order and
        // makes its subtree fully non-interactive — aria-hidden alone
        // does not, so the close button and links would still be
        // tabbable behind the scenes.
        if (!isOpen) 'inert': '',
      },
      events: {'keydown': _onKeyDown},
      [
        div(
          classes: 'neo-drawer-backdrop',
          events: {'click': _onBackdropClick},
          [],
        ),
        aside(
          classes: 'neo-drawer-panel',
          attributes: const {'role': 'dialog', 'aria-modal': 'true'},
          [
            div(classes: 'neo-drawer-header', [
              if (title != null) h2(classes: 'neo-drawer-title', [.text(title!)]),
              button(
                classes: 'neo-drawer-close',
                type: ButtonType.button,
                attributes: {'aria-label': closeLabel},
                onClick: onClose,
                [
                  const AppIcon(
                    IconPaths.close,
                    width: 20,
                    height: 20,
                    strokeWidth: '3',
                  ),
                ],
              ),
            ]),
            div(classes: 'neo-drawer-body', children),
          ],
        ),
      ],
    );
  }
}
