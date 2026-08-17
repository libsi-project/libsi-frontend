// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailedPackage _$DetailedPackageFromJson(Map<String, dynamic> json) =>
    DetailedPackage(
      id: json['id'] as String,
      title: json['title'] as String,
      gameType: json['gameType'] as String,
      difficultyType: json['difficultyType'] as String,
      difficulty: json['difficulty'] as String,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
      topicsCount: (json['topicsCount'] as num).toInt(),
      publishDate: Pack.dateFromJson((json['publishDate'] as num).toInt()),
      playDate: Pack.dateFromJson((json['playDate'] as num).toInt()),
      likesCount: (json['likesCount'] as num).toInt(),
      dislikesCount: (json['dislikesCount'] as num).toInt(),
      description: json['description'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailedPackageToJson(DetailedPackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'gameType': instance.gameType,
      'difficultyType': instance.difficultyType,
      'difficulty': instance.difficulty,
      'authors': instance.authors,
      'topicsCount': instance.topicsCount,
      'publishDate': Pack.dateToJson(instance.publishDate),
      'playDate': Pack.dateToJson(instance.playDate),
      'likesCount': instance.likesCount,
      'dislikesCount': instance.dislikesCount,
      'description': instance.description,
      'topics': instance.topics,
    };
