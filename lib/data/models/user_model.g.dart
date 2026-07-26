// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      connectCount: (json['connect_count'] as num).toInt(),
      publicProfile: json['public_profile'] as bool,
      isCreator: json['is_creator'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'connect_count': instance.connectCount,
      'public_profile': instance.publicProfile,
      'is_creator': instance.isCreator,
      'created_at': instance.createdAt.toIso8601String(),
    };
