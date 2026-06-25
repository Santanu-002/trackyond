import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';

part 'send_otp_response_model.freezed.dart';
part 'send_otp_response_model.g.dart';

@freezed
sealed class SendOtpResponseModel with _$SendOtpResponseModel implements SendOtpResponseEntity {
  const factory SendOtpResponseModel({
    required String phone,
    required String otpId,
    required DateTime expiresAt,
    DateTime? resendableAt,
    required int remainingAttempts,
  }) = _SendOtpResponseModel;

  const SendOtpResponseModel._();

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseModelFromJson(json);

  factory SendOtpResponseModel.fromEntity(SendOtpResponseEntity entity) =>
      SendOtpResponseModel(
        phone: entity.phone,
        otpId: entity.otpId,
        expiresAt: entity.expiresAt,
        resendableAt: entity.resendableAt,
        remainingAttempts: entity.remainingAttempts,
      );
}
