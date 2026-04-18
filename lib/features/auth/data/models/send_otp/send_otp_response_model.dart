import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/send_otp_response_entity.dart';

part 'send_otp_response_model.freezed.dart';
part 'send_otp_response_model.g.dart';

@freezed
sealed class SendOtpResponseModel with _$SendOtpResponseModel {
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

  SendOtpResponseEntity toEntity() => SendOtpResponseEntity(
    phone: phone,
    otpId: otpId,
    expiresAt: expiresAt,
    resendableAt: resendableAt,
    remainingAttempts: remainingAttempts,
  );

  factory SendOtpResponseModel.fromEntity(SendOtpResponseEntity entity) =>
      SendOtpResponseModel(
        phone: entity.phone,
        otpId: entity.otpId,
        expiresAt: entity.expiresAt,
        resendableAt: entity.resendableAt,
        remainingAttempts: entity.remainingAttempts,
      );
}
