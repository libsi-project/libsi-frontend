// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  answer: json['answer'] as String,
  additionalAnswers: json['additionalAnswers'] as String?,
  wrongAnswers: json['wrongAnswers'] as String?,
  comment: json['comment'] as String?,
  source: json['source'] as String?,
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'answer': instance.answer,
  'additionalAnswers': instance.additionalAnswers,
  'wrongAnswers': instance.wrongAnswers,
  'comment': instance.comment,
  'source': instance.source,
};
