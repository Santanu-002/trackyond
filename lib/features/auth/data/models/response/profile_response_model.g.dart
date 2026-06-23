// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileResponseModel _$ProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => _ProfileResponseModel(
  profile: json['profile'] == null
      ? null
      : MemberProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileResponseModelToJson(
  _ProfileResponseModel instance,
) => <String, dynamic>{
  'profile': instance.profile?.toJson(),
  'company': instance.company?.toJson(),
};
