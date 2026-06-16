import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/presentation/features/pack/model/pack.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';

abstract class PackEvent {}

class GetPacksEvent implements PackEvent {}

sealed class PackState {}

class PackLoadingState implements PackState {}

class PackLoadedState implements PackState {
  final List<Pack> packs;

  PackLoadedState({required this.packs});
}

class PackErrorState implements PackState {
  final String error;

  PackErrorState({required this.error});
}

class PackBloc extends Bloc<PackEvent, PackState> {
  final PackUseCase packUseCase;

  PackBloc(this.packUseCase) : super(PackLoadingState()) {
    on<GetPacksEvent>(_onGetPacks);
  }

  Future<void> _onGetPacks(
    GetPacksEvent event,
    Emitter<PackState> emit,
  ) async {
    final result = await packUseCase.getPacks();
    result.handler(
      onResult: (packs) => emit(PackLoadedState(packs: packs)),
      onError: (error) => emit(PackErrorState(error: error ?? 'Unknown error')),
    );
  }
}
