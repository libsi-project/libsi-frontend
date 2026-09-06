import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/components/page_container.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class PlaceholderPage extends StatelessComponent {
  const PlaceholderPage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Component build(BuildContext context) {
    final l10n = context.l10n;

    return PageContainer(
      styles: Styles(
        padding: Padding.only(
          left: NeoTokens.pagePaddingX.rem,
          right: NeoTokens.pagePaddingX.rem,
          top: 3.rem,
          bottom: 3.rem,
        ),
      ),
      children: [
        NeoCard(
          interactive: false,
          styles: Styles(maxWidth: 560.px),
          children: [
            h1(
              styles: NeoStyles.text(
                family: NeoTokens.fontDisplay,
                size: 2,
                weight: FontWeight.w800,
              ),
              [.text(title)],
            ),
            p(
              styles: NeoStyles.text(color: AppTheme.textSecondary, size: 1),
              [.text(l10n.comingSoon)],
            ),
          ],
        ),
      ],
    );
  }
}
