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

  // TODO: drop the mock coercion once the backend returns enum slugs
  // for `gameType` and populates `audiences`. Until then we normalise
  // mockapi's free-form strings so `Pack.fromJson` can parse them.
  static const _gameTypeCycle = ['eruditeSextet', 'ksi', 'isi'];
  static const _russianGameTypeToSlug = {
    'Эрудит-Квартет': 'eruditeQuartet',
    'Эрудит-Сикстет': 'eruditeSextet',
    'ИСИ': 'isi',
    'КСИ': 'ksi',
    'Иное': 'other',
  };
  static const _defaultAudiences = ['schooler', 'student', 'adult'];

  @override
  Future<List<Pack>> getPacks() async {
    final response = await dio.get<List<dynamic>>('/packs');
    final data = response.data ?? const [];
    return data.asMap().entries.map((entry) {
      final json = Map<String, dynamic>.from(entry.value as Map);
      _normaliseGameType(json, entry.key);
      json['audiences'] ??= _defaultAudiences;
      return Pack.fromJson(json);
    }).toList();
  }

  static void _normaliseGameType(Map<String, dynamic> json, int index) {
    final raw = (json['gameType'] as String?)?.trim() ?? '';
    if (raw.startsWith('gameType ')) {
      json['gameType'] = _gameTypeCycle[index % _gameTypeCycle.length];
      return;
    }
    final mapped = _russianGameTypeToSlug[raw];
    if (mapped != null) {
      json['gameType'] = mapped;
    }
  }
}
