// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwitchProfileModel _$SwitchProfileModelFromJson(Map<String, dynamic> json) =>
    _SwitchProfileModel(
      profileUid: json['profileUid'] as String,
      userUid: json['userUid'] as String,
      name: json['name'] as String,
      designation: json['designation'] as String,
      image: json['image'] as String?,
      company: SwitchProfileCompanyModel.fromJson(
        json['company'] as Map<String, dynamic>,
      ),
      isPrimary: json['isPrimary'] as bool,
    );

Map<String, dynamic> _$SwitchProfileModelToJson(_SwitchProfileModel instance) =>
    <String, dynamic>{
      'profileUid': instance.profileUid,
      'userUid': instance.userUid,
      'name': instance.name,
      'designation': instance.designation,
      'image': instance.image,
      'company': instance.company,
      'isPrimary': instance.isPrimary,
    };

_SwitchProfileCompanyModel _$SwitchProfileCompanyModelFromJson(
  Map<String, dynamic> json,
) => _SwitchProfileCompanyModel(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$SwitchProfileCompanyModelToJson(
  _SwitchProfileCompanyModel instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
