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

  // TODO: drop the placeholder swap once mockapi stops returning
  // strings like "gameType 3". The backend will send real values and
  // this cycle can go.
  static const _mockGameTypes = ['Эрудит-Сикстет', 'КСИ', 'ИСИ'];

  @override
  Future<List<Pack>> getPacks() async {
    final response = await dio.get<List<dynamic>>('/packs');
    final data = response.data ?? const [];
    return data.asMap().entries.map((entry) {
      final json = Map<String, dynamic>.from(entry.value as Map);
      final gameType = json['gameType'] as String? ?? '';
      if (gameType.startsWith('gameType ')) {
        json['gameType'] = _mockGameTypes[entry.key % _mockGameTypes.length];
      }
      return Pack.fromJson(json);
    }).toList();
  }
}
