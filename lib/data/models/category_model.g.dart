// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      categoryTag: json['category_tag'] as String,
      visibility: json['visibility'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      memberCount: (json['member_count'] as num?)?.toInt(),
      lastActivity: json['last_activity'] == null
          ? null
          : DateTime.parse(json['last_activity'] as String),
      thumbnailUrl: json['thumbnail_url'] as String?,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'category_tag': instance.categoryTag,
      'visibility': instance.visibility,
      'created_at': instance.createdAt.toIso8601String(),
      'member_count': instance.memberCount,
      'last_activity': instance.lastActivity?.toIso8601String(),
      'thumbnail_url': instance.thumbnailUrl,
    };
