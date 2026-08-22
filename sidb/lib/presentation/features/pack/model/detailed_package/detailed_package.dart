import 'package:json_annotation/json_annotation.dart';
import 'package:sidb/presentation/features/pack/model/author/author.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/pack/model/topic/topic.dart';

part 'detailed_package.g.dart';

@JsonSerializable()
class DetailedPackage extends Pack {
  DetailedPackage({
    required super.id,
    required super.title,
    required super.gameType,
    required super.difficultyType,
    required super.difficulty,
    required super.averageAnswersPercentage,
    required super.authors,
    required super.topicsCount,
    required super.publishDate,
    required super.playDate,
    required super.likesCount,
    required super.dislikesCount,
    required this.description,
    required this.topics,
  });

  final String description;
  final List<Topic> topics;

  factory DetailedPackage.fromJson(Map<String, dynamic> json) => _$DetailedPackageFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DetailedPackageToJson(this);
}
