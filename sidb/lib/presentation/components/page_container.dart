import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Centers a page's content and caps it at [NeoTokens.pageMaxWidth].
///
/// The app shell no longer applies a horizontal padding of its own —
/// full-width chrome (top bar, footer) uses its own inner container,
/// while ordinary pages wrap themselves in one of these.
class PageContainer extends StatelessComponent {
  const PageContainer({required this.children, this.classes, this.styles, super.key});

  final List<Component> children;
  final String? classes;
  final Styles? styles;

  @css
  static List<StyleRule> get pageStyles => [
    css('.page-container').styles(
      display: Display.block,
      width: 100.percent,
      maxWidth: NeoTokens.pageMaxWidth.px,
      padding: Padding.symmetric(horizontal: 20.px),
      margin: Margin.symmetric(horizontal: Unit.auto),
    ),
  ];

  @override
  Component build(BuildContext context) {
    return div(
      classes: ['page-container', ?classes].join(' '),
      styles: styles,
      children,
    );
  }
}
