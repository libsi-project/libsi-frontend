import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int id;
  final String text;
  final String answer;
  final String? additionalAnswers;
  final String? wrongAnswers;
  final String? comment;
  final String? source;

  Question({
    required this.id,
    required this.text,
    required this.answer,
    required this.additionalAnswers,
    required this.wrongAnswers,
    required this.comment,
    required this.source,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
