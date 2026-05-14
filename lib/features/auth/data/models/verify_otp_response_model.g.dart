// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerifyOtpResponseModel _$VerifyOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => _VerifyOtpResponseModel(
  userUid: json['userUid'] as String,
  phone: json['phone'] as String,
  isNewUser: json['isNewUser'] as bool? ?? false,
  primaryProfileUid: json['primaryProfileUid'] as String?,
  role: UserRole.fromString(json['role']),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  accessExpireAt: json['accessExpireAt'] as String,
  refreshExpireAt: json['refreshExpireAt'] as String,
  tokenIssuedAt: json['tokenIssuedAt'] as String,
  profile: json['profile'] == null
      ? null
      : MemberProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VerifyOtpResponseModelToJson(
  _VerifyOtpResponseModel instance,
) => <String, dynamic>{
  'userUid': instance.userUid,
  'phone': instance.phone,
  'isNewUser': instance.isNewUser,
  'primaryProfileUid': instance.primaryProfileUid,
  'role': _$UserRoleEnumMap[instance.role]!,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'accessExpireAt': instance.accessExpireAt,
  'refreshExpireAt': instance.refreshExpireAt,
  'tokenIssuedAt': instance.tokenIssuedAt,
  'profile': instance.profile,
  'company': instance.company,
};

const _$UserRoleEnumMap = {UserRole.owner: 'owner', UserRole.worker: 'worker'};
