import 'package:json_annotation/json_annotation.dart';

part 'content_model.g.dart';

@JsonSerializable()
class ContentModel {
  final String id;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'file_url')
  final String fileUrl;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @JsonKey(name: 'file_type')
  final String fileType;
  final String? caption;
  final Map<String, dynamic>? location;
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;

  ContentModel({
    required this.id,
    required this.categoryId,
    required this.ownerId,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.fileType,
    this.caption,
    this.location,
    required this.uploadedAt,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContentModelToJson(this);
  
  bool get isVideo => fileType.startsWith('video/');
  bool get isImage => fileType.startsWith('image/');
}
