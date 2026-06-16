import 'package:json_annotation/json_annotation.dart';

part 'pack.g.dart';

@JsonSerializable()
class Pack {
  final String id;
  final String title;
  final String gameType;
  final String difficultyType;
  final String difficulty;
  final List<String> authors;
  final int topicsCount;
  @JsonKey(
    fromJson: _dateFromJson,
    toJson: _dateToJson,
  )
  final DateTime publishDate;
  @JsonKey(
    fromJson: _dateFromJson,
    toJson: _dateToJson,
  )
  final DateTime playDate;
  final int likesCount;
  final int dislikesCount;

  Pack({
    required this.id,
    required this.title,
    required this.gameType,
    required this.difficultyType,
    required this.difficulty,
    required this.authors,
    required this.topicsCount,
    required this.publishDate,
    required this.playDate,
    required this.likesCount,
    required this.dislikesCount,
  });

  Map<String, dynamic> toJson() => _$PackToJson(this);
  factory Pack.fromJson(Map<String, dynamic> json) => _$PackFromJson(json);

  static DateTime _dateFromJson(int dateJson) => DateTime.fromMillisecondsSinceEpoch(dateJson * 1000);
  static int _dateToJson(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;
}
