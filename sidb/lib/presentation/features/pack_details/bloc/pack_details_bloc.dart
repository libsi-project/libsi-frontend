import 'package:jaspr_bloc/jaspr_bloc.dart';
import 'package:sidb/presentation/features/pack/model/detailed_package/detailed_package.dart';
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart';

abstract class PackDetailsEvent {}

class LoadPackDetailsEvent implements PackDetailsEvent {
  LoadPackDetailsEvent(this.id);
  final String id;
}

sealed class PackDetailsState {}

class PackDetailsLoadingState implements PackDetailsState {}

class PackDetailsLoadedState implements PackDetailsState {
  PackDetailsLoadedState(this.pack);
  final DetailedPackage pack;
}

class PackDetailsNotFoundState implements PackDetailsState {}

class PackDetailsErrorState implements PackDetailsState {
  PackDetailsErrorState(this.error);
  final String error;
}

class PackDetailsBloc extends Bloc<PackDetailsEvent, PackDetailsState> {
  PackDetailsBloc(this._useCase) : super(PackDetailsLoadingState()) {
    on<LoadPackDetailsEvent>(_onLoad);
  }

  final PackUseCase _useCase;

  Future<void> _onLoad(LoadPackDetailsEvent event, Emitter<PackDetailsState> emit) async {
    emit(PackDetailsLoadingState());
    final result = await _useCase.getPackDetails(event.id);
    result.handler(
      onResult: (pack) => emit(
        pack == null ? PackDetailsNotFoundState() : PackDetailsLoadedState(pack),
      ),
      onError: (error) => emit(PackDetailsErrorState(error ?? 'Unknown error')),
    );
  }
}
