// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) =>
    _CompanyModel(
      uid: json['companyId'] as String,
      name: json['companyName'] as String,
      teamSize: (json['teamSize'] as num).toInt(),
      ownerUid: json['ownerUid'] as String,
    );

Map<String, dynamic> _$CompanyModelToJson(_CompanyModel instance) =>
    <String, dynamic>{
      'companyId': instance.uid,
      'companyName': instance.name,
      'teamSize': instance.teamSize,
      'ownerUid': instance.ownerUid,
    };
