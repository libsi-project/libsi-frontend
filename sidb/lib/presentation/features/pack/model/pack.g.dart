// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pack _$PackFromJson(Map<String, dynamic> json) => Pack(
  id: json['id'] as String,
  title: json['title'] as String,
  gameType: json['gameType'] as String,
  difficultyType: json['difficultyType'] as String,
  difficulty: json['difficulty'] as String,
  authors: (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
  topicsCount: (json['topicsCount'] as num).toInt(),
  publishDate: Pack._dateFromJson((json['publishDate'] as num).toInt()),
  playDate: Pack._dateFromJson((json['playDate'] as num).toInt()),
  likesCount: (json['likesCount'] as num).toInt(),
  dislikesCount: (json['dislikesCount'] as num).toInt(),
);

Map<String, dynamic> _$PackToJson(Pack instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'gameType': instance.gameType,
  'difficultyType': instance.difficultyType,
  'difficulty': instance.difficulty,
  'authors': instance.authors,
  'topicsCount': instance.topicsCount,
  'publishDate': Pack._dateToJson(instance.publishDate),
  'playDate': Pack._dateToJson(instance.playDate),
  'likesCount': instance.likesCount,
  'dislikesCount': instance.dislikesCount,
};
