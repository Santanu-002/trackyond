class AppStrings {
  const AppStrings._();

  static const common = CommonStrings();
  static const auth = AuthStrings();
  static const admin = AdminStrings();
  static const chooseRole = ChooseRoleStrings();
  static const sendOtp = SendOtpStrings();
  static const verifyOtp = VerifyOtpStrings();
}

class CommonStrings {
  const CommonStrings();

  String get appName => 'Trackyond';

  String get welcome => 'Welcome to Trackyond';
}

class AuthStrings {
  const AuthStrings();

  String get login => 'Login';

  String get register => 'Register';

  String get email => 'Email';

  String get password => 'Password';

  String get confirmPassword => 'Confirm Password';
}

class AdminStrings {
  const AdminStrings();

  String get welcomeBack => 'Welcome Back,';

  String get adminName => 'Luminous Admin';

  String get welcomeSub => 'Manage your workspace with ease and clarity.';

  String get phoneNumber => 'Phone Number';

  String get phoneHint => '+91 00000 00000';

  String get sendOtp => 'Send Verification Code';

  String get terms => 'By continuing, you agree to our Terms of Service';

  String get verifyIdentity => 'Verify Identity';

  String get otpSentTo => 'We have sent a 6-digit code to\n';

  String get resendOtp => 'Resend Verification Code';

  String get verifyAndContinue => 'Verify and Continue';

  String get loginSuccess => 'Login Successful';

  String get enterPhone => 'Please enter a phone number';

  String get enterOtp => 'Please enter a 6-digit OTP';
}

class ChooseRoleStrings {
  const ChooseRoleStrings();

  String get title => 'Precision Management';

  String get subtitle =>
      'Select your role to continue with Trackyond’s curated workflow.';

  String get loginEmployee => 'Login as Employee';

  String get loginCompany => 'Login as company';
}

class SendOtpStrings {
  const SendOtpStrings();

  String get ownerTitle => 'Company Portal';
  String get ownerSubtitle =>
      'Enter your company phone number to access the dashboard.';

  String get workerTitle => 'Employee Access';
  String get workerSubtitle =>
      'Enter your registered phone number to log into your account.';

  String get phoneLabel => 'Phone Number';
  String get phoneHint => '00000 00000';
  String get buttonText => 'Get Verification Code';
  String get footerText =>
      'By proceeding, you agree to our Terms and Privacy Policy';
}

class VerifyOtpStrings {
  const VerifyOtpStrings();

  String get title => 'Verify Identity';
  String subtitle(String phone) => 'Enter the 6-digit code we sent to\n$phone';

  String get otpLabel => 'Verification Code';
  String get otpHint => '000 000';
  String get buttonText => 'Verify and Continue';

  String get resendText => "Didn't receive the code?";
  String get resendButton => 'Resend Verification Code';
  String resendIn(int seconds) => 'Resend in ${seconds}s';
}
