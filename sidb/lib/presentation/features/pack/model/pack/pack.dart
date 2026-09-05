import 'package:json_annotation/json_annotation.dart';
import 'package:sidb/presentation/features/pack/model/author/author.dart';
import 'package:sidb/presentation/features/pack/model/game_type/game_type.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';

part 'pack.g.dart';

@JsonSerializable()
class Pack {
  final String id;
  final String title;
  // TODO: drop the tolerant fallback once the backend stops returning
  // free-form / placeholder strings like "gameType 3" and switches to
  // the enum slugs (`erudite_quartet`, `isi`, ...).
  @JsonKey(fromJson: gameTypeFromJson, toJson: gameTypeToJson)
  final GameType gameType;
  // TODO: drop the fallback once the backend returns `audiences`. Until
  // then we surface every possible tag so the badges are visible on
  // the packs list without touching the mock server.
  @JsonKey(fromJson: audiencesFromJson, toJson: audiencesToJson)
  final List<TargetAudience> audiences;
  final double? averageAnswersPercentage;
  final List<Author> authors;
  final int topicsCount;
  @JsonKey(
    fromJson: dateFromJson,
    toJson: dateToJson,
  )
  final DateTime publishDate;
  @JsonKey(
    fromJson: dateFromJson,
    toJson: dateToJson,
  )
  final DateTime playDate;
  final int likesCount;
  final int dislikesCount;

  Pack({
    required this.id,
    required this.title,
    required this.gameType,
    required this.audiences,
    required this.averageAnswersPercentage,
    required this.authors,
    required this.topicsCount,
    required this.publishDate,
    required this.playDate,
    required this.likesCount,
    required this.dislikesCount,
  });

  Map<String, dynamic> toJson() => _$PackToJson(this);
  factory Pack.fromJson(Map<String, dynamic> json) => _$PackFromJson(json);

  static DateTime dateFromJson(int dateJson) => DateTime.fromMillisecondsSinceEpoch(dateJson * 1000);
  static int dateToJson(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

  static List<TargetAudience> audiencesFromJson(dynamic json) {
    if (json is List) {
      return json
          .whereType<String>()
          .map(_audienceFromString)
          .whereType<TargetAudience>()
          .toList();
    }
    return TargetAudience.values;
  }

  static List<String> audiencesToJson(List<TargetAudience> audiences) =>
      audiences.map(_audienceToString).toList();

  static TargetAudience? _audienceFromString(String value) => switch (value) {
    'schooler' => TargetAudience.schooler,
    'student' => TargetAudience.student,
    'adult' => TargetAudience.adult,
    _ => null,
  };

  static String _audienceToString(TargetAudience audience) => switch (audience) {
    TargetAudience.schooler => 'schooler',
    TargetAudience.student => 'student',
    TargetAudience.adult => 'adult',
  };

  static GameType gameTypeFromJson(dynamic json) {
    if (json is! String) return GameType.other;
    return switch (json.trim().toLowerCase()) {
      'erudite_quartet' || 'эрудит-квартет' => GameType.eruditeQuartet,
      'erudite_sextet' || 'эрудит-сикстет' => GameType.eruditeSextet,
      'isi' || 'иси' => GameType.isi,
      'ksi' || 'кси' => GameType.ksi,
      'other' || 'иное' => GameType.other,
      _ => GameType.other,
    };
  }

  static String gameTypeToJson(GameType type) => switch (type) {
    GameType.eruditeQuartet => 'erudite_quartet',
    GameType.eruditeSextet => 'erudite_sextet',
    GameType.isi => 'isi',
    GameType.ksi => 'ksi',
    GameType.other => 'other',
  };
}
