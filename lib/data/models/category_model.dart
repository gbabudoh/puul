import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  final String name;
  @JsonKey(name: 'category_tag')
  final String categoryTag;
  final String visibility;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'member_count')
  final int? memberCount;
  @JsonKey(name: 'last_activity')
  final DateTime? lastActivity;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  CategoryModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.categoryTag,
    required this.visibility,
    required this.createdAt,
    this.memberCount,
    this.lastActivity,
    this.thumbnailUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
