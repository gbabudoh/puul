import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? email;
  @JsonKey(name: 'connect_count')
  final int connectCount;
  @JsonKey(name: 'public_profile')
  final bool publicProfile;
  @JsonKey(name: 'is_creator')
  final bool isCreator;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.phoneNumber,
    this.email,
    required this.connectCount,
    required this.publicProfile,
    required this.isCreator,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
