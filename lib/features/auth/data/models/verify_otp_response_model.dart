import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/features/auth/data/models/user/user_model.dart';

part 'verify_otp_response_model.freezed.dart';

@freezed
sealed class VerifyOtpResponseModel with _$VerifyOtpResponseModel {
  const factory VerifyOtpResponseModel({
    required String userUid,
    required String phoneNo,
    required bool isNewUser,
    required String accessToken,
    required String refreshToken,
    required String accessExpireAt,
    required String refreshExpireAt,
    required String tokenIssuedAt,
  }) = _VerifyOtpResponseModel;

  const VerifyOtpResponseModel._();

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      userUid: json['userUid'] as String,
      phoneNo: json['phoneNo'] as String,
      isNewUser: json['isNewUser'] as bool,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessExpireAt: json['accessExpireAt'] as String,
      refreshExpireAt: json['refreshExpireAt'] as String,
      tokenIssuedAt: json['tokenIssuedAt'] as String,
    );
  }

  AuthTokens get tokens => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    accessExpireAt: accessExpireAt,
    refreshExpireAt: refreshExpireAt,
    tokenIssuedAt: tokenIssuedAt,
  );

  UserModel getUser(UserRole role) =>
      UserModel(uid: userUid, phone: phoneNo, role: role, isNewUser: isNewUser);
}
