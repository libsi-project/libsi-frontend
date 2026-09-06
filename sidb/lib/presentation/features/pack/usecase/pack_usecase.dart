import 'package:injectable/injectable.dart';
import 'package:sidb/core/usecase/usecase.dart';
import 'package:sidb/presentation/features/pack/model/detailed_package/detailed_package.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/pack/repository/pack_repository.dart';

@LazySingleton()
class PackUseCase extends UseCase {
  final PackRepository packRepository;

  PackUseCase(this.packRepository);

  Future<Result<List<Pack>>> getPacks() async => await handle(() => packRepository.getPacks());

  Future<Result<DetailedPackage?>> getPackDetails(String id) async =>
      await handle(() => packRepository.getPackDetails(id));
}
