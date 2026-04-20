// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) =>
    _CompanyModel(
      companyId: json['companyId'] as String,
      companyName: json['companyName'] as String,
      userPhoneNo: json['userPhoneNo'] as String,
      teamSize: (json['teamSize'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CompanyModelToJson(_CompanyModel instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'userPhoneNo': instance.userPhoneNo,
      'teamSize': instance.teamSize,
      'createdAt': instance.createdAt,
    };
