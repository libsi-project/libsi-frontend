import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_drawer.dart';
import 'package:sidb/presentation/features/pack/model/topic/topic.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Left-hand contents/navigation for the pack details page.
class PackTopicSidebar extends StatefulComponent {
  const PackTopicSidebar({required this.topics, super.key});

  final List<Topic> topics;

  @css
  static List<StyleRule> get styles => [
    css('.pd-sidebar').styles(
      display: Display.none,
      flex: Flex(shrink: 0),
    ),
    css('.pd-sidebar-list').styles(
      display: Display.flex,
      padding: Padding.all(1.25.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.5.rem),
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '6px 6px 0 0 var(--theme-border)'},
    ),
    css('.pd-sidebar-heading').styles(
      margin: Margin.only(bottom: 0.5.rem),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.85.rem,
      fontWeight: FontWeight.w800,
      textTransform: TextTransform.upperCase,
      letterSpacing: 0.05.em,
    ),
    css('.pd-sidebar-item').styles(
      display: Display.block,
      padding: Padding.symmetric(horizontal: 12.px, vertical: 8.px),
      border: Border.all(style: BorderStyle.solid, width: 2.px, color: Colors.transparent),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none', 'text-align': 'left'},
    ),
    css('.pd-sidebar-item:hover').styles(
      border: NeoTokens.border(width: NeoTokens.borderThin),
      backgroundColor: AppTheme.accentColor,
    ),
    css('.pd-sidebar-item:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.pd-sidebar-toggle').styles(
      display: Display.inlineFlex,
      position: Position.fixed(bottom: 1.5.rem, right: 1.5.rem),
      zIndex: ZIndex(90),
      width: 56.px,
      height: 56.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '5px 5px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-sidebar-toggle:hover').styles(
      transform: Transform.translate(x: 2.px, y: 2.px),
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)'},
    ),
    css('.pd-sidebar-toggle:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '4px'},
    ),
    css.media(MediaQuery.screen(minWidth: 1024.px), [
      css('.pd-sidebar').styles(display: Display.block),
      css('.pd-sidebar-list').styles(
        position: Position.sticky(top: 100.px),
      ),
      css('.pd-sidebar-toggle').styles(display: Display.none),
    ]),
  ];

  @override
  State<PackTopicSidebar> createState() => _PackTopicSidebarState();
}

class _PackTopicSidebarState extends State<PackTopicSidebar> {
  bool _drawerOpen = false;

  void _openDrawer() => setState(() => _drawerOpen = true);
  void _closeDrawer() => setState(() => _drawerOpen = false);

  void _scrollTo(String anchorId) {
    final element = web.document.getElementById(anchorId);
    if (element == null) return;
    element.scrollIntoView(
      web.ScrollIntoViewOptions(behavior: 'smooth', block: 'start'),
    );
    _closeDrawer();
  }

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final items = _buildItems();
    return Component.fragment([
      aside(
        classes: 'pd-sidebar',
        attributes: const {'aria-label': 'Оглавление'},
        [
          div(classes: 'pd-sidebar-list', [
            span(classes: 'pd-sidebar-heading', [.text(l10n.topicsHeading)]),
            ...items,
          ]),
        ],
      ),
      button(
        classes: 'pd-sidebar-toggle',
        type: ButtonType.button,
        attributes: {
          'aria-label': l10n.openContents,
          'aria-expanded': _drawerOpen ? 'true' : 'false',
        },
        onClick: _openDrawer,
        [
          const AppIcon(IconPaths.menu, width: 24, height: 24, strokeWidth: '3'),
        ],
      ),
      NeoDrawer(
        isOpen: _drawerOpen,
        onClose: _closeDrawer,
        title: l10n.topicsHeading,
        closeLabel: l10n.closeContents,
        children: items,
      ),
    ]);
  }

  List<Component> _buildItems() {
    return [
      for (final topic in component.topics)
        button(
          classes: 'pd-sidebar-item',
          type: ButtonType.button,
          onClick: () => _scrollTo('topic-${topic.id}'),
          [.text(topic.title)],
        ),
    ];
  }
}
