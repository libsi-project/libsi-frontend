import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/features/pack_details/view/pack_scoreboard_scope.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Floating scoreboard rendered on top of the pack details page.
///
/// Sits as a persistent right-hand column on desktop (≥1024px) and
/// as a slide-up bottom sheet on mobile. State (open/closed) comes
/// from a [ScoreboardScope] so the trigger button and the panel can
/// live at different points in the tree.
class PackScorePanel extends StatefulComponent {
  const PackScorePanel({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.pd-scoreboard').styles(
      display: Display.flex,
      position: Position.fixed(bottom: 0.px, right: 0.px, left: 0.px),
      zIndex: ZIndex(80),
      maxHeight: 70.vh,
      padding: Padding.all(1.25.rem),
      border: Border.only(
        top: BorderSide.solid(width: NeoTokens.borderThick.px, color: AppTheme.borderColor),
      ),
      transition: Transition('transform', duration: NeoTokens.motionSlowMs.ms),
      transform: Transform.translate(y: 100.percent),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
      color: AppTheme.textColor,
      backgroundColor: AppTheme.canvasColor,
    ),
    css('.pd-scoreboard-open').styles(
      transform: Transform.translate(y: 0.percent),
    ),
    css('.pd-scoreboard-header').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: Gap.all(1.rem),
    ),
    css('.pd-scoreboard-title').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.35.rem,
      fontWeight: FontWeight.w800,
    ),
    css('.pd-scoreboard-close').styles(
      display: Display.inlineFlex,
      width: 40.px,
      height: 40.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-scoreboard-close:hover').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.pd-scoreboard-close:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-scoreboard-players').styles(
      display: Display.flex,
      padding: Padding.symmetric(vertical: 4.px, horizontal: 4.px),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
    ),
    css('.pd-scoreboard-picker').styles(
      display: Display.flex,
      alignItems: AlignItems.stretch,
      gap: Gap.all(6.px),
    ),
    css('.pd-scoreboard-picker-select').styles(
      display: Display.block,
      padding: Padding.symmetric(horizontal: 10.px, vertical: 8.px),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      cursor: Cursor.pointer,
      flex: Flex(grow: 1),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.surfaceColor,
      raw: {
        'appearance': 'none',
        'box-shadow': '3px 3px 0 0 var(--theme-border)',
        'outline': 'none',
        'background-image':
            "url(\"data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='3' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'/%3e%3c/svg%3e\")",
        'background-repeat': 'no-repeat',
        'background-position': 'right 10px center',
        'background-size': '16px 16px',
        'padding-right': '32px',
      },
    ),
    css('.pd-scoreboard-picker-select:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.pd-scoreboard-quick-add').styles(
      display: Display.inlineFlex,
      width: 40.px,
      height: 40.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.3.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-scoreboard-quick-add:hover').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.pd-scoreboard-quick-add:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-player').styles(
      display: Display.none,
    ),
    css('.pd-player-current').styles(
      display: Display.flex,
      position: Position.relative(),
      padding: Padding.all(0.75.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.5.rem),
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
    ),
    css('.pd-player-name').styles(
      width: 100.percent,
      padding: Padding.only(left: 8.px, right: 30.px, top: 6.px, bottom: 6.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.85.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.canvasColor,
      raw: {'outline': 'none'},
    ),
    css('.pd-player-name:focus').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '-3px'},
    ),
    css('.pd-player-score').styles(
      padding: Padding.symmetric(vertical: 4.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.75.rem,
      fontWeight: FontWeight.w800,
      lineHeight: 1.em,
      backgroundColor: AppTheme.canvasColor,
    ),
    css('.pd-player-nominal').styles(
      display: Display.flex,
      alignItems: AlignItems.stretch,
      gap: Gap.all(4.px),
    ),
    css('.pd-player-nominal-btn').styles(
      display: Display.inlineFlex,
      width: 32.px,
      height: 32.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.1.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-player-nominal-btn:hover').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '1px 1px 0 0 var(--theme-border)'},
    ),
    css('.pd-player-nominal-btn:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-player-nominal-input').styles(
      width: 100.percent,
      minWidth: 0.px,
      padding: Padding.symmetric(horizontal: 4.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.canvasColor,
      raw: {'outline': 'none'},
    ),
    css('.pd-player-remove').styles(
      display: Display.inlineFlex,
      position: Position.absolute(top: 4.px, right: 4.px),
      width: 22.px,
      height: 22.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textSecondary,
      backgroundColor: AppTheme.canvasColor,
      raw: {'outline': 'none'},
    ),
    css('.pd-player-remove:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.pd-player-remove:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.pd-scoreboard-add').styles(
      display: Display.none,
      minWidth: 140.px,
      padding: Padding.all(0.75.rem),
      border: Border.all(style: BorderStyle.dashed, width: 3.px, color: AppTheme.borderColor),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: Colors.transparent,
      raw: {'outline': 'none'},
    ),
    css('.pd-scoreboard-add:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.pd-scoreboard-add:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css.media(MediaQuery.screen(minWidth: 1024.px), [
      css('.pd-scoreboard').styles(
        position: Position.sticky(top: 100.px),
        zIndex: ZIndex(1),
        maxHeight: 100.percent,
        padding: Padding.all(1.25.rem),
        border: NeoTokens.border(width: NeoTokens.borderThick),
        radius: NeoTokens.radius(NeoTokens.radiusNone),
        transform: Transform.translate(y: 0.percent),
        backgroundColor: AppTheme.surfaceColor,
        raw: {'box-shadow': '6px 6px 0 0 var(--theme-border)'},
      ),
      css('.pd-scoreboard-close').styles(display: Display.none),
      css('.pd-scoreboard-picker').styles(display: Display.none),
      css('.pd-scoreboard-add').styles(display: Display.inlineFlex),
      css('.pd-scoreboard-players').styles(
        overflow: Overflow.only(y: Overflow.auto),
        flexDirection: FlexDirection.column,
        flex: Flex(grow: 1),
      ),
      css('.pd-player').styles(
        display: Display.flex,
        position: Position.relative(),
        width: 100.percent,
        padding: Padding.all(0.75.rem),
        border: NeoTokens.border(width: NeoTokens.borderThick),
        flexDirection: FlexDirection.column,
        gap: Gap.all(0.5.rem),
        backgroundColor: AppTheme.surfaceColor,
        raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
      ),
    ]),
  ];

  @override
  State<PackScorePanel> createState() => _PackScorePanelState();
}

class _PackScorePanelState extends State<PackScorePanel> {
  final List<_Player> _players = [_Player()];
  int _selectedIndex = 0;
  ScoreboardController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ScoreboardScope.of(context);
    if (controller != _controller) {
      _controller?.removeListener(_onControllerChanged);
      _controller = controller..addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _addPlayer() => setState(() {
    _players.add(_Player());
    _selectedIndex = _players.length - 1;
  });

  void _removePlayer(int index) {
    if (_players.length <= 1) return;
    setState(() {
      _players.removeAt(index);
      if (index < _selectedIndex) {
        _selectedIndex -= 1;
      } else if (_selectedIndex >= _players.length) {
        _selectedIndex = _players.length - 1;
      }
    });
  }

  void _selectPlayer(int index) {
    if (index < 0 || index >= _players.length || index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  void _setName(int index, String name) {
    setState(() => _players[index].name = name);
  }

  void _setNominal(int index, int nominal) {
    setState(() => _players[index].nominal = nominal);
  }

  void _bumpScore(int index, int delta) {
    setState(() => _players[index].score += delta);
  }

  String _playerLabel(int index) {
    final name = _players[index].name.trim();
    return name.isEmpty
        ? 'Игрок ${index + 1}'
        : name;
  }

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final isOpen = _controller?.isOpen ?? false;
    return div(
      classes: ['pd-scoreboard', if (isOpen) 'pd-scoreboard-open'].join(' '),
      // No aria-hidden here — on desktop the panel is always visible
      // via CSS regardless of `isOpen`, so hiding it from assistive
      // tech would misrepresent the state. Mobile visibility is
      // controlled by the transform (offscreen elements aren't
      // reached by pointer or focus anyway).
      [
        div(classes: 'pd-scoreboard-header', [
          h3(classes: 'pd-scoreboard-title', [.text(l10n.scoreboardTitle)]),
          button(
            classes: 'pd-scoreboard-close',
            type: ButtonType.button,
            attributes: {'aria-label': l10n.packCloseScoreboard},
            onClick: () => _controller?.close(),
            [
              const AppIcon(IconPaths.close, width: 18, height: 18, strokeWidth: '3'),
            ],
          ),
        ]),
        div(classes: 'pd-scoreboard-players', [
          div(classes: 'pd-scoreboard-picker', [
            select(
              [
                for (var i = 0; i < _players.length; i++)
                  option(
                    [.text(_playerLabel(i))],
                    value: '$i',
                    selected: i == _selectedIndex,
                  ),
              ],
              classes: 'pd-scoreboard-picker-select',
              attributes: {'aria-label': l10n.scoreboardTitle},
              events: {
                'change': (event) {
                  final target = event.target as web.HTMLSelectElement;
                  final parsed = int.tryParse(target.value);
                  if (parsed != null) _selectPlayer(parsed);
                },
              },
            ),
            button(
              classes: 'pd-scoreboard-quick-add',
              type: ButtonType.button,
              attributes: {'aria-label': l10n.scoreboardAddPlayer, 'title': l10n.scoreboardAddPlayer},
              onClick: _addPlayer,
              [.text('+')],
            ),
          ]),
          for (var i = 0; i < _players.length; i++) _playerColumn(context, i),
          button(
            classes: 'pd-scoreboard-add',
            type: ButtonType.button,
            onClick: _addPlayer,
            [.text('+ ${l10n.scoreboardAddPlayer}')],
          ),
        ]),
      ],
    );
  }

  Component _playerColumn(BuildContext context, int index) {
    final l10n = context.l10n;
    final player = _players[index];
    return div(
      key: ValueKey(index),
      classes: ['pd-player', if (index == _selectedIndex) 'pd-player-current'].join(' '),
      [
        if (_players.length > 1)
          button(
            classes: 'pd-player-remove',
            type: ButtonType.button,
            attributes: {'aria-label': l10n.scoreboardRemovePlayer},
            onClick: () => _removePlayer(index),
            [
              const AppIcon(IconPaths.close, width: 14, height: 14, strokeWidth: '3'),
            ],
          ),
        input(
          classes: 'pd-player-name',
          attributes: {
            'type': 'text',
            'placeholder': '${l10n.scoreboardPlayerNamePlaceholder} ${index + 1}',
            'value': player.name,
            'aria-label': l10n.scoreboardPlayerNamePlaceholder,
          },
          events: {
            'input': (event) {
              final target = event.target as web.HTMLInputElement;
              _setName(index, target.value);
            },
          },
        ),
        div(classes: 'pd-player-score', [.text('${player.score}')]),
        div(classes: 'pd-player-nominal', [
          button(
            classes: 'pd-player-nominal-btn',
            type: ButtonType.button,
            attributes: {'aria-label': l10n.scoreboardDecrease},
            onClick: () => _bumpScore(index, -player.nominal),
            [.text('−')],
          ),
          input(
            classes: 'pd-player-nominal-input',
            attributes: {
              'type': 'number',
              'inputmode': 'numeric',
              'min': '10',
              'step': '10',
              'value': '${player.nominal}',
              'aria-label': l10n.scoreboardNominal,
            },
            events: {
              'input': (event) {
                final target = event.target as web.HTMLInputElement;
                final parsed = int.tryParse(target.value);
                if (parsed != null && parsed > 0) _setNominal(index, parsed);
              },
            },
          ),
          button(
            classes: 'pd-player-nominal-btn',
            type: ButtonType.button,
            attributes: {'aria-label': l10n.scoreboardIncrease},
            onClick: () => _bumpScore(index, player.nominal),
            [.text('+')],
          ),
        ]),
      ],
    );
  }
}

/// Mobile-only floating button that opens the scoreboard.
class PackScoreboardTrigger extends StatefulComponent {
  const PackScoreboardTrigger({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.pd-score-trigger').styles(
      display: Display.inlineFlex,
      position: Position.fixed(bottom: 1.5.rem, right: 5.5.rem),
      zIndex: ZIndex(90),
      width: 56.px,
      height: 56.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusNone),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.onPrimaryColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '5px 5px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-score-trigger:hover').styles(
      transform: Transform.translate(x: 2.px, y: 2.px),
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)'},
    ),
    css('.pd-score-trigger:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '4px'},
    ),
    css.media(MediaQuery.screen(minWidth: 1024.px), [
      css('.pd-score-trigger').styles(display: Display.none),
    ]),
  ];

  @override
  State<PackScoreboardTrigger> createState() => _PackScoreboardTriggerState();
}

class _PackScoreboardTriggerState extends State<PackScoreboardTrigger> {
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
    return button(
      classes: 'pd-score-trigger',
      type: ButtonType.button,
      attributes: {
        'aria-label': isOpen ? l10n.packCloseScoreboard : l10n.packOpenScoreboard,
        'aria-pressed': isOpen ? 'true' : 'false',
      },
      onClick: () => _controller?.toggle(),
      [.text('#')],
    );
  }
}

class _Player {
  String name = '';
  int score = 0;
  int nominal = 10;
}
