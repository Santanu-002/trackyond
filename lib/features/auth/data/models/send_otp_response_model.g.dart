// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendOtpResponseModel _$SendOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => _SendOtpResponseModel(
  phone: json['phone'] as String,
  otpId: json['otpId'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  resendableAt: json['resendableAt'] == null
      ? null
      : DateTime.parse(json['resendableAt'] as String),
  remainingAttempts: (json['remainingAttempts'] as num).toInt(),
);

Map<String, dynamic> _$SendOtpResponseModelToJson(
  _SendOtpResponseModel instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'otpId': instance.otpId,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'resendableAt': instance.resendableAt?.toIso8601String(),
  'remainingAttempts': instance.remainingAttempts,
};
