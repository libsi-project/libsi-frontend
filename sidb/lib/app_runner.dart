import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/config/localization/extension.dart';
import 'package:sidb/core/di/di.dart';
import 'package:sidb/presentation/components/app_dialog.dart';
import 'package:sidb/presentation/features/about/view/about.dart';
import 'package:sidb/presentation/features/developer_faq/view/developer_faq_page.dart';
import 'package:sidb/presentation/features/not_found/view/not_found_page.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';
import 'package:sidb/presentation/features/pack/view/packs_page.dart';
import 'package:sidb/presentation/features/placeholder/view/placeholder_page.dart';
import 'package:sidb/presentation/features/search/view/search_page.dart';
import 'package:sidb/presentation/theme/theme_cubit.dart';

import 'package:sidb/presentation/components/footer_neo.dart';
import 'package:sidb/presentation/components/top_bar_neo.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

// The main component of your application.
class AppRunner extends StatelessComponent {
  const AppRunner({super.key});

  @override
  Component build(BuildContext context) {
    return _BlocProviders(
      child: AppDialogHost(
        child: router.Router(
          errorBuilder: (context, state) => _AppShell(
            location: state.location,
            child: NotFoundPage(path: state.location),
          ),
          routes: [
            router.ShellRoute(
              builder: (context, state, child) => _AppShell(
                location: state.location,
                initialSearchQuery: state.queryParams['q'],
                child: child,
              ),
              routes: [
                router.Route(path: '/', title: 'Home', builder: (context, state) => const PacksPage()),
                router.Route(path: '/about', title: 'About', builder: (context, state) => const About()),
                router.Route(
                  path: '/developer-faq',
                  title: 'Developer FAQ',
                  builder: (context, state) => const DeveloperFaqPage(),
                ),
                router.Route(
                  path: '/search',
                  title: 'Search',
                  builder: (context, state) => const SearchPage(),
                ),
                router.Route(
                  path: '/authors',
                  title: 'Authors',
                  builder: (context, state) => PlaceholderPage(title: context.l10n.authors),
                ),
                router.Route(
                  path: '/favorites',
                  title: 'Favorites',
                  builder: (context, state) => PlaceholderPage(title: context.l10n.favorites),
                ),
                router.Route(
                  path: '/faq',
                  title: 'FAQ',
                  builder: (context, state) => PlaceholderPage(title: context.l10n.faq),
                ),
                router.Route(
                  path: '/feedback',
                  title: 'Feedback',
                  builder: (context, state) => PlaceholderPage(title: context.l10n.contact),
                ),
                router.Route(
                  path: '/license',
                  title: 'License',
                  builder: (context, state) => PlaceholderPage(title: context.l10n.licensing),
                ),
                router.Route(
                  path: '/:rest(.*)',
                  title: '404',
                  builder: (context, state) => NotFoundPage(path: state.location),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppShell extends StatelessComponent {
  const _AppShell({
    required this.location,
    this.initialSearchQuery,
    required this.child,
  });

  final String location;
  final String? initialSearchQuery;
  final Component child;

  @override
  Component build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) => div(
        styles: Styles(
          display: Display.flex,
          height: 100.vh,
          overflow: Overflow.hidden,
          justifyContent: JustifyContent.center,
        ),
        [
          div(
            classes: 'app-shell',
            styles: Styles(
              display: Display.flex,
              width: 100.percent,
              height: 100.percent,
              maxWidth: NeoTokens.pageMaxWidth.px,
              padding: Padding.symmetric(horizontal: 20.px),
              overflow: Overflow.only(y: Overflow.auto),
              flexDirection: FlexDirection.column,
            ),
            [
              TopBarNeo(
                location: location,
                initialSearchQuery: initialSearchQuery,
              ),
              div(
                styles: Styles(
                  display: Display.flex,
                  minHeight: 0.px,
                  flexDirection: FlexDirection.column,
                  flex: Flex(grow: 1),
                ),
                [
                  div(
                    styles: Styles(
                      flex: Flex(grow: 1),
                    ),
                    [child],
                  ),
                  const FooterNeo(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BlocProviders extends StatelessComponent {
  const _BlocProviders({required this.child});

  final Component child;

  @override
  Component build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<PackBloc>(
          create: (context) => PackBloc(
            getIt<PackUseCase>(),
          )..add(GetPacksEvent()),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
