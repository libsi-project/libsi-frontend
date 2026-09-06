import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/features/pack/model/topic/topic.dart';
import 'package:sidb/presentation/features/pack_details/view/pack_scoreboard_scope.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Contents/navigation for the pack details page.
///
/// Mobile shows a full-width `<select>` dropdown of topics sitting
/// sticky above the content (horizontal chip strips overflow the
/// viewport). Desktop switches to the classic sticky column of
/// buttons on the left. Selecting a topic smooth-scrolls to
/// `#topic-{id}`.
class PackTopicSidebar extends StatelessComponent {
  const PackTopicSidebar({required this.topics, super.key});

  final List<Topic> topics;

  @css
  static List<StyleRule> get styles => [
    css('.pd-sidebar').styles(
      display: Display.block,
      position: Position.sticky(top: 100.px),
      zIndex: ZIndex(70),
      flex: Flex(shrink: 0),
      raw: {'align-self': 'flex-start'},
    ),
    css('.pd-sidebar-mobile-row').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.stretch,
      gap: Gap.all(8.px),
    ),
    css('.pd-sidebar-scoreboard-btn').styles(
      display: Display.inlineFlex,
      width: 44.px,
      height: 44.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.onPrimaryColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-sidebar-scoreboard-btn:hover').styles(
      transform: Transform.translate(x: 2.px, y: 2.px),
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.pd-sidebar-scoreboard-btn:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-sidebar-select').styles(
      display: Display.block,
      maxWidth: 220.px,
      padding: Padding.symmetric(horizontal: 12.px, vertical: 10.px),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'appearance': 'none',
        'box-shadow': '4px 4px 0 0 var(--theme-border)',
        'outline': 'none',
        'background-image':
            "url(\"data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='3' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'/%3e%3c/svg%3e\")",
        'background-repeat': 'no-repeat',
        'background-position': 'right 12px center',
        'background-size': '18px 18px',
        'padding-right': '40px',
      },
    ),
    css('.pd-sidebar-select:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-sidebar-list').styles(
      display: Display.none,
    ),
    css('.pd-sidebar-heading').styles(
      display: Display.none,
    ),
    css('.pd-sidebar-item').styles(
      display: Display.block,
      padding: Padding.symmetric(horizontal: 10.px, vertical: 6.px),
      border: Border.none,
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      alignItems: AlignItems.start,
      flex: Flex(shrink: 1),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.85.rem,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      lineHeight: 1.2.em,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none', 'text-align': 'left'},
    ),
    css('.pd-sidebar-item:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.pd-sidebar-item:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css.media(MediaQuery.screen(minWidth: 1024.px), [
      css('.pd-sidebar-mobile-row').styles(display: Display.none),
      css('.pd-sidebar-list').styles(
        display: Display.flex,
        padding: Padding.all(12.px),
        border: NeoTokens.border(width: NeoTokens.borderThick),
        overflow: Overflow.only(y: Overflow.auto),
        flexDirection: FlexDirection.column,
        gap: Gap.all(2.px),
        backgroundColor: AppTheme.surfaceColor,
        raw: {'box-shadow': '6px 6px 0 0 var(--theme-border)', 'max-height': 'calc(100vh - 120px)'},
      ),
      css('.pd-sidebar-heading').styles(
        display: Display.block,
        padding: Padding.only(bottom: 4.px, left: 6.px),
        color: AppTheme.textSecondary,
        fontFamily: const FontFamily(NeoTokens.fontDisplay),
        fontSize: 0.7.rem,
        fontWeight: FontWeight.w800,
        textTransform: TextTransform.upperCase,
        letterSpacing: 0.05.em,
      ),
    ]),
  ];

  static void _scrollTo(String anchorId) {
    final element = web.document.getElementById(anchorId);
    if (element == null) return;
    element.scrollIntoView(
      web.ScrollIntoViewOptions(behavior: 'smooth', block: 'start'),
    );
  }

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return aside(
      classes: 'pd-sidebar',
      attributes: {'aria-label': l10n.topicsHeading},
      [
        div(classes: 'pd-sidebar-mobile-row', [
          const _ScoreboardToggleButton(),
          select(
            [
              option([.text(l10n.topicsHeading)], value: '', selected: true, disabled: true),
              for (final topic in topics)
                option([.text(topic.title)], value: 'topic-${topic.id}'),
            ],
            classes: 'pd-sidebar-select',
            attributes: {'aria-label': l10n.topicsHeading},
            events: {
              'change': (event) {
                final target = event.target as web.HTMLSelectElement;
                final id = target.value;
                if (id.isEmpty) return;
                _scrollTo(id);
                target.value = '';
              },
            },
          ),
        ]),
        div(classes: 'pd-sidebar-list', [
          span(classes: 'pd-sidebar-heading', [.text(l10n.topicsHeading)]),
          for (final topic in topics)
            button(
              classes: 'pd-sidebar-item',
              type: ButtonType.button,
              onClick: () => _scrollTo('topic-${topic.id}'),
              [.text(topic.title)],
            ),
        ]),
      ],
    );
  }
}

class _ScoreboardToggleButton extends StatefulComponent {
  const _ScoreboardToggleButton();

  @override
  State<_ScoreboardToggleButton> createState() =>
      _ScoreboardToggleButtonState();
}

class _ScoreboardToggleButtonState extends State<_ScoreboardToggleButton> {
  ScoreboardController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ScoreboardScope.of(context);
    if (controller != _controller) {
      _controller?.removeListener(_onChanged);
      _controller = controller..addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final isOpen = _controller?.isOpen ?? false;
    final label = isOpen ? l10n.packCloseScoreboard : l10n.packOpenScoreboard;
    return button(
      classes: 'pd-sidebar-scoreboard-btn',
      type: ButtonType.button,
      attributes: {
        'aria-label': label,
        'aria-pressed': isOpen ? 'true' : 'false',
        'title': label,
      },
      onClick: () => _controller?.toggle(),
      [.text('#')],
    );
  }
}
