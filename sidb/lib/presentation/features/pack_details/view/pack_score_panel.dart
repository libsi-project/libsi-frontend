import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Floating scoreboard rendered on top of the pack details page.
class PackScorePanel extends StatefulComponent {
  const PackScorePanel({
    required this.isOpen,
    required this.onClose,
    super.key,
  });

  final bool isOpen;
  final VoidCallback onClose;

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
      radius: NeoTokens.radius(NeoTokens.radiusSm),
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
      overflow: Overflow.only(x: Overflow.auto),
      flexDirection: FlexDirection.row,
      gap: Gap.all(1.rem),
    ),
    css('.pd-player').styles(
      display: Display.flex,
      position: Position.relative(),
      minWidth: 200.px,
      padding: Padding.all(1.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
      flex: Flex(shrink: 0),
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '5px 5px 0 0 var(--theme-border)'},
    ),
    css('.pd-player-name').styles(
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 10.px, vertical: 8.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.canvasColor,
      raw: {'outline': 'none'},
    ),
    css('.pd-player-name:focus').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '-3px'},
    ),
    css('.pd-player-score').styles(
      padding: Padding.symmetric(vertical: 8.px),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 2.5.rem,
      fontWeight: FontWeight.w800,
      lineHeight: 1.em,
      backgroundColor: AppTheme.canvasColor,
    ),
    css('.pd-player-nominal').styles(
      display: Display.flex,
      alignItems: AlignItems.stretch,
      gap: Gap.all(6.px),
    ),
    css('.pd-player-nominal-btn').styles(
      display: Display.inlineFlex,
      width: 40.px,
      height: 40.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
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
    css('.pd-player-nominal-btn:hover').styles(
      transform: Transform.translate(x: 1.px, y: 1.px),
      backgroundColor: AppTheme.primaryColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)'},
    ),
    css('.pd-player-nominal-btn:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '3px'},
    ),
    css('.pd-player-nominal-input').styles(
      width: 100.percent,
      padding: Padding.symmetric(horizontal: 8.px),
      border: NeoTokens.border(width: NeoTokens.borderThin),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      color: AppTheme.textColor,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.canvasColor,
      raw: {'outline': 'none'},
    ),
    css('.pd-player-remove').styles(
      display: Display.inlineFlex,
      position: Position.absolute(top: (-10).px, right: (-10).px),
      width: 28.px,
      height: 28.px,
      padding: Padding.zero,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusPill),
      cursor: Cursor.pointer,
      transition: NeoTokens.transition(NeoTokens.motionFastMs),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppTheme.textColor,
      backgroundColor: AppTheme.surfaceColor,
      raw: {'box-shadow': '2px 2px 0 0 var(--theme-border)', 'outline': 'none'},
    ),
    css('.pd-player-remove:hover').styles(
      backgroundColor: AppTheme.accentColor,
    ),
    css('.pd-player-remove:focus-visible').styles(
      raw: {'outline': '3px solid var(--theme-accent)', 'outline-offset': '2px'},
    ),
    css('.pd-scoreboard-add').styles(
      display: Display.inlineFlex,
      minWidth: 200.px,
      padding: Padding.all(1.rem),
      border: Border.all(style: BorderStyle.dashed, width: 3.px, color: AppTheme.borderColor),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
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
    css.media(MediaQuery.screen(minWidth: 768.px), [
      css('.pd-scoreboard').styles(
        position: Position.fixed(top: 100.px, bottom: 1.5.rem, right: 1.5.rem),
        maxWidth: 30.rem,
        maxHeight: 100.percent,
        border: NeoTokens.border(width: NeoTokens.borderThick),
        radius: NeoTokens.radius(NeoTokens.radiusLg),
        transform: Transform.translate(x: 120.percent),
        raw: {'box-shadow': '8px 8px 0 0 var(--theme-border)'},
      ),
      css('.pd-scoreboard-open').styles(
        transform: Transform.translate(x: 0.percent),
      ),
      css('.pd-scoreboard-players').styles(
        overflow: Overflow.only(y: Overflow.auto),
        flex: Flex(grow: 1),
      ),
    ]),
  ];

  @override
  State<PackScorePanel> createState() => _PackScorePanelState();
}

class _PackScorePanelState extends State<PackScorePanel> {
  final List<_Player> _players = [_Player()];

  void _addPlayer() => setState(() => _players.add(_Player()));

  void _removePlayer(int index) {
    if (_players.length <= 1) return;
    setState(() => _players.removeAt(index));
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

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    return div(
      classes: [
        'pd-scoreboard',
        if (component.isOpen) 'pd-scoreboard-open',
      ].join(' '),
      attributes: {
        'aria-hidden': component.isOpen ? 'false' : 'true',
        if (!component.isOpen) 'inert': '',
      },
      [
        div(classes: 'pd-scoreboard-header', [
          h3(classes: 'pd-scoreboard-title', [.text(l10n.scoreboardTitle)]),
          button(
            classes: 'pd-scoreboard-close',
            type: ButtonType.button,
            attributes: {'aria-label': l10n.packCloseScoreboard},
            onClick: component.onClose,
            [
              const AppIcon(IconPaths.close, width: 18, height: 18, strokeWidth: '3'),
            ],
          ),
        ]),
        div(classes: 'pd-scoreboard-players', [
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
      classes: 'pd-player',
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
              'min': '1',
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

class _Player {
  String name = '';
  int score = 0;
  int nominal = 10;
}
