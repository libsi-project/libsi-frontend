import 'package:json_annotation/json_annotation.dart';
import 'package:sidb/presentation/features/pack/model/author/author.dart';
import 'package:sidb/presentation/features/pack/model/question/question.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  final int id;
  final String title;
  final String? description;
  final List<Author>? authors;
  final List<Question>? questions;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.authors,
    required this.questions,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
