import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/features/pack/model/question/question.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// A single question row with its collapsible answer block.
class PackQuestionCard extends StatefulComponent {
  const PackQuestionCard({required this.question, super.key});

  final Question question;

  @css
  static List<StyleRule> get styles => [
    css('.pd-question').styles(
      display: Display.flex,
      padding: Padding.all(1.25.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusMd),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
      backgroundColor: AppTheme.canvasColor,
      raw: {
        'box-shadow': '4px 4px 0 0 var(--theme-border)',
        'scroll-margin-top': '100px',
      },
    ),
    css('.pd-question-row').styles(
      display: Display.flex,
      flexDirection: FlexDirection.row,
      alignItems: AlignItems.start,
      gap: Gap.all(1.rem),
    ),
    css('.pd-question-points').styles(
      display: Display.inlineFlex,
      width: 56.px,
      height: 56.px,
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      flex: Flex(shrink: 0),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 1.35.rem,
      fontWeight: FontWeight.w800,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '3px 3px 0 0 var(--theme-border)'},
    ),
    css('.pd-question-text').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 1.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
    ),
    css('.pd-question-text-block').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
      flex: Flex(grow: 1),
    ),
    css('.pd-answer').styles(
      display: Display.flex,
      padding: Padding.all(1.rem),
      border: Border.all(style: BorderStyle.dashed, width: 2.px, color: AppTheme.borderColor),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.6.rem),
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.pd-answer-row').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.px),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w600,
      lineHeight: 1.5.em,
    ),
    css('.pd-answer-label').styles(
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontDisplay),
      fontSize: 0.75.rem,
      fontWeight: FontWeight.w800,
      textTransform: TextTransform.upperCase,
      letterSpacing: 0.05.em,
    ),
  ];

  @override
  State<PackQuestionCard> createState() => _PackQuestionCardState();
}

class _PackQuestionCardState extends State<PackQuestionCard> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  String get _anchorId => 'q-${component.question.id}';

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;
    final question = component.question;
    final position = question.id % 100;
    final points = (position + 1) * 10;
    return div(
      id: _anchorId,
      classes: 'pd-question',
      [
        div(classes: 'pd-question-row', [
          span(classes: 'pd-question-points', [.text('$points')]),
          div(classes: 'pd-question-text-block', [
            p(classes: 'pd-question-text', [.text(question.text)]),
            NeoButton(
              variant: _isOpen ? NeoButtonVariant.accent : NeoButtonVariant.surface,
              size: NeoButtonSize.sm,
              onClick: _toggle,
              attributes: {'aria-expanded': _isOpen ? 'true' : 'false'},
              children: [
                .text(_isOpen ? l10n.hideAnswer : l10n.showAnswer),
              ],
            ),
          ]),
        ]),
        if (_isOpen) _answer(l10n, question),
      ],
    );
  }

  Component _answer(Translations l10n, Question question) {
    return div(classes: 'pd-answer', [
      _row(l10n.questionAnswer, question.answer),
      if (question.additionalAnswers != null && question.additionalAnswers!.isNotEmpty)
        _row(l10n.questionAdditionalAnswers, question.additionalAnswers!),
      if (question.wrongAnswers != null && question.wrongAnswers!.isNotEmpty)
        _row(l10n.questionWrongAnswers, question.wrongAnswers!),
      if (question.comment != null && question.comment!.isNotEmpty)
        _row(l10n.questionComment, question.comment!),
      if (question.source != null && question.source!.isNotEmpty)
        _row(l10n.questionSource, question.source!),
    ]);
  }

  Component _row(String label, String value) {
    return div(classes: 'pd-answer-row', [
      span(classes: 'pd-answer-label', [.text(label)]),
      span([.text(value)]),
    ]);
  }
}
