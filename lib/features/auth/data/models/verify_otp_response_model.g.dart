// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerifyOtpResponseModel _$VerifyOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => _VerifyOtpResponseModel(
  userUid: json['userUid'] as String,
  phoneNo: json['phoneNo'] as String,
  isNewUser: json['isNewUser'] as bool? ?? false,
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  accessExpireAt: json['accessExpireAt'] as String,
  refreshExpireAt: json['refreshExpireAt'] as String,
  tokenIssuedAt: json['tokenIssuedAt'] as String,
);

Map<String, dynamic> _$VerifyOtpResponseModelToJson(
  _VerifyOtpResponseModel instance,
) => <String, dynamic>{
  'userUid': instance.userUid,
  'phoneNo': instance.phoneNo,
  'isNewUser': instance.isNewUser,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'accessExpireAt': instance.accessExpireAt,
  'refreshExpireAt': instance.refreshExpireAt,
  'tokenIssuedAt': instance.tokenIssuedAt,
};
