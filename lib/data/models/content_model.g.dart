// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentModel _$ContentModelFromJson(Map<String, dynamic> json) => ContentModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      ownerId: json['owner_id'] as String,
      fileUrl: json['file_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      fileType: json['file_type'] as String,
      caption: json['caption'] as String?,
      location: json['location'] as Map<String, dynamic>?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
    );

Map<String, dynamic> _$ContentModelToJson(ContentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'owner_id': instance.ownerId,
      'file_url': instance.fileUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'file_type': instance.fileType,
      'caption': instance.caption,
      'location': instance.location,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
    };
