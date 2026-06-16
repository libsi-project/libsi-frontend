//import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:jaspr_router/jaspr_router.dart';

extension BuildContextExt on BuildContext {
  bool get isMobileView {
    return false;
    //return MediaQuery.sizeOf(this).width < 600 || MediaQuery.sizeOf(this).width < MediaQuery.sizeOf(this).height;
  }

  T bloc<T extends StateStreamableSource<Object?>>() {
    try {
      return BlocProvider.of<T>(this);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != T) rethrow;
      throw Exception(
        '''
        BlocProvider.of() called with a context that does not contain a $T.
        No ancestor could be found starting from the context that was passed to BlocProvider.of<$T>().

        This can happen if the context you used comes from a widget above the BlocProvider.

        The context used was: $this
        ''',
      );
    }
  }

  RouterState get router => Router.of(this);

  T valueFor<T>(T mobile, T web) => isMobileView ? mobile : web;

  T? maybeBloc<T extends StateStreamableSource<Object?>>() {
    try {
      return bloc<T>();
    } catch (e) {
      return null;
    }
  }
}
