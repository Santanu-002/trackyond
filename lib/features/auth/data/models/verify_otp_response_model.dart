import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/features/auth/data/models/user/user_model.dart';

part 'verify_otp_response_model.freezed.dart';
part 'verify_otp_response_model.g.dart';

@freezed
sealed class VerifyOtpResponseModel with _$VerifyOtpResponseModel {
  const factory VerifyOtpResponseModel({
    required String userUid,
    @JsonKey(name: 'phone') required String phone,
    @Default(false) bool isNewUser,
    String? primaryAccountUid,
    @JsonKey(fromJson: UserRole.fromString) required UserRole role,
    required String accessToken,
    required String refreshToken,
    required String accessExpireAt,
    required String refreshExpireAt,
    required String tokenIssuedAt,
  }) = _VerifyOtpResponseModel;

  const VerifyOtpResponseModel._();

  // ---------------------------------------------------------------------------
  // Named Factories
  // ---------------------------------------------------------------------------

  /// Generic deserializer — used internally by the named factories below.
  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);

  /// For **owner / admin** responses — reads [isNewUser] from the JSON payload.
  factory VerifyOtpResponseModel.fromOwnerJson(Map<String, dynamic> json) =>
      VerifyOtpResponseModel.fromJson(json);

  /// For **employee / member** responses — [isNewUser] is always false because
  /// members are pre-registered by an admin before they can authenticate.
  /// Explicitly overrides the key even if the server accidentally includes it.
  factory VerifyOtpResponseModel.fromMemberJson(Map<String, dynamic> json) =>
      VerifyOtpResponseModel.fromJson({...json, 'isNewUser': false});

  // ---------------------------------------------------------------------------
  // Computed Helpers
  // ---------------------------------------------------------------------------

  AuthTokens get tokens => AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessExpireAt: accessExpireAt,
        refreshExpireAt: refreshExpireAt,
        tokenIssuedAt: tokenIssuedAt,
      );

  UserModel getUser(UserRole role) => UserModel(
        uid: userUid,
        phone: phone,
        role: role,
        isNewUser: isNewUser,
        primaryAccountUid: primaryAccountUid,
      );
}
