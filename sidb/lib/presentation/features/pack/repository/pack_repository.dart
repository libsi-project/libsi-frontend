import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sidb/presentation/features/pack/model/detailed_package/detailed_package.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/pack/model/question/question.dart';
import 'package:sidb/presentation/features/pack/model/topic/topic.dart';

abstract class PackRepository {
  Future<List<Pack>> getPacks();

  /// Returns null when no pack exists for [id].
  Future<DetailedPackage?> getPackDetails(String id);
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

  // TODO: swap the client-side mock topics for a real
  // GET /packs/{id} endpoint once the backend ships it.
  @override
  Future<DetailedPackage?> getPackDetails(String id) async {
    final packs = await getPacks();
    final base = packs.where((p) => p.id == id).firstOrNull;
    if (base == null) return null;
    return DetailedPackage(
      id: base.id,
      title: base.title,
      gameType: base.gameType,
      audiences: base.audiences,
      averageAnswersPercentage: base.averageAnswersPercentage,
      authors: base.authors,
      topicsCount: base.topicsCount,
      publishDate: base.publishDate,
      playDate: base.playDate,
      likesCount: base.likesCount,
      dislikesCount: base.dislikesCount,
      description: _mockDescription,
      topics: _mockTopics(base),
    );
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

  static const String _mockDescription =
      'Пакет собран из авторских вопросов, отыгранных на профильных турнирах. Ниже — темы и вопросы; ответ раскрывается по клику.';

  static List<Topic> _mockTopics(Pack base) {
    final topicCount = base.topicsCount.clamp(1, 6);
    return List<Topic>.generate(topicCount, (i) {
      final index = i + 1;
      return Topic(
        id: index,
        title: 'Тема $index — ${base.title}',
        description: 'Описание темы $index для демонстрации',
        authors: base.authors,
        questions: List<Question>.generate(5, (q) {
          final points = (q + 1) * 10;
          return Question(
            id: index * 100 + q,
            text:
                'Вопрос за $points очков в теме «Тема $index». Здесь будет полный текст вопроса из пакета, отображаемый до раскрытия ответа.',
            answer: 'Ответ на вопрос за $points очков',
            additionalAnswers: q.isEven ? 'Также принимается: вариант A, вариант B' : null,
            wrongAnswers: q == 2 ? 'Не принимается: очевидно неверный ответ' : null,
            comment: q == 0 ? 'Комментарий: контекст и пояснение к вопросу' : null,
            source: q == 4 ? 'Источник: https://example.org' : null,
          );
        }),
      );
    });
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
