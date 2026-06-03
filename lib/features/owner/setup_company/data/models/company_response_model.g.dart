// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompanyResponseModel _$CompanyResponseModelFromJson(
  Map<String, dynamic> json,
) => _CompanyResponseModel(
  memberProfile: MemberProfileModel.fromJson(
    json['ownerProfile'] as Map<String, dynamic>,
  ),
  company: CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompanyResponseModelToJson(
  _CompanyResponseModel instance,
) => <String, dynamic>{
  'ownerProfile': instance.memberProfile.toJson(),
  'company': instance.company.toJson(),
};
