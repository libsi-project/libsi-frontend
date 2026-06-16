import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart' as router;
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/core/di/di.dart';
import 'package:sidb/presentation/features/about/view/about.dart';
import 'package:sidb/presentation/features/pack/bloc/pack_bloc.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';
import 'package:sidb/presentation/features/pack/view/packs_page.dart';

import 'presentation/components/top_bar_neo_circ.dart';
import 'presentation/theme/theme_cubit.dart';

// The main component of your application.
class AppRunner extends StatelessComponent {
  const AppRunner({super.key});

  @override
  Component build(BuildContext context) {
    return _BlocProviders(
      child: router.Router(
        routes: [
          router.ShellRoute(
            builder: (context, state, child) => BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) => div(
                classes: 'flex h-screen overflow-hidden',
                attributes: {'data-theme': mode.name},
                [
                  div(
                    classes: 'flex-1 flex flex-col min-w-0',
                    [
                      TopBarNeo(location: state.location),
                      div(
                        classes: 'flex-1 overflow-y-auto p-8 nb-bg',
                        [child],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            routes: [
              router.Route(path: '/', title: 'Home', builder: (context, state) => const PacksPage()),
              router.Route(path: '/about', title: 'About', builder: (context, state) => const About()),
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
