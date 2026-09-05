// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pack _$PackFromJson(Map<String, dynamic> json) => Pack(
  id: json['id'] as String,
  title: json['title'] as String,
  gameType: $enumDecode(_$GameTypeEnumMap, json['gameType']),
  audiences: (json['audiences'] as List<dynamic>)
      .map((e) => $enumDecode(_$TargetAudienceEnumMap, e))
      .toList(),
  averageAnswersPercentage: (json['averageAnswersPercentage'] as num?)
      ?.toDouble(),
  authors: (json['authors'] as List<dynamic>)
      .map((e) => Author.fromJson(e as Map<String, dynamic>))
      .toList(),
  topicsCount: (json['topicsCount'] as num).toInt(),
  publishDate: Pack.dateFromJson((json['publishDate'] as num).toInt()),
  playDate: Pack.dateFromJson((json['playDate'] as num).toInt()),
  likesCount: (json['likesCount'] as num).toInt(),
  dislikesCount: (json['dislikesCount'] as num).toInt(),
);

Map<String, dynamic> _$PackToJson(Pack instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'gameType': _$GameTypeEnumMap[instance.gameType]!,
  'audiences': instance.audiences
      .map((e) => _$TargetAudienceEnumMap[e]!)
      .toList(),
  'averageAnswersPercentage': instance.averageAnswersPercentage,
  'authors': instance.authors,
  'topicsCount': instance.topicsCount,
  'publishDate': Pack.dateToJson(instance.publishDate),
  'playDate': Pack.dateToJson(instance.playDate),
  'likesCount': instance.likesCount,
  'dislikesCount': instance.dislikesCount,
};

const _$GameTypeEnumMap = {
  GameType.eruditeQuartet: 'eruditeQuartet',
  GameType.eruditeSextet: 'eruditeSextet',
  GameType.isi: 'isi',
  GameType.ksi: 'ksi',
  GameType.other: 'other',
};

const _$TargetAudienceEnumMap = {
  TargetAudience.schooler: 'schooler',
  TargetAudience.student: 'student',
  TargetAudience.adult: 'adult',
};
