import 'package:json_annotation/json_annotation.dart';
import 'package:sidb/presentation/features/pack/model/author/author.dart';
import 'package:sidb/presentation/features/pack/model/game_type/game_type.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';

part 'pack.g.dart';

@JsonSerializable()
class Pack {
  final String id;
  final String title;
  final GameType gameType;
  final List<TargetAudience> audiences;
  final double? averageAnswersPercentage;
  final List<Author> authors;
  final int topicsCount;
  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  final DateTime publishDate;
  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
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
}
