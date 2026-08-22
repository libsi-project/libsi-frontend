import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';

abstract class PackRepository {
  Future<List<Pack>> getPacks();
}

@Injectable(as: PackRepository)
class ApiPackRepository implements PackRepository {
  final Dio dio;

  ApiPackRepository(this.dio);

  @override
  Future<List<Pack>> getPacks() async {
    final response = await dio.get<List<dynamic>>('/packs');
    return response.data?.map((e) => Pack.fromJson(e)).toList() ?? [];
  }
}
