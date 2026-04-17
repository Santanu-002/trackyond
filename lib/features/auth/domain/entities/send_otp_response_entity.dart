class SendOtpResponseEntity {
  final String phone;
  final String otpId;
  final DateTime expiresAt;
  final DateTime? resendableAt;
  final int remainingAttempts;

  const SendOtpResponseEntity({
    required this.phone,
    required this.otpId,
    required this.expiresAt,
    this.resendableAt,
    required this.remainingAttempts,
  });
}
