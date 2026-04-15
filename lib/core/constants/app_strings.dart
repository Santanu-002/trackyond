class AppStrings {
  const AppStrings._();

  static const CommonStrings common = CommonStrings();
  static const AuthStrings auth = AuthStrings();
  static const AdminStrings admin = AdminStrings();
}

class CommonStrings {
  const CommonStrings();
  final String appName = 'Trackyond';
  final String welcome = 'Welcome to Trackyond';
}


class AuthStrings {
  const AuthStrings();
  final String login = 'Login';
  final String register = 'Register';
  final String email = 'Email';
  final String password = 'Password';
  final String confirmPassword = 'Confirm Password';
}

class AdminStrings {
  const AdminStrings();
  final String welcomeBack = 'Welcome Back,';
  final String adminName = 'Luminous Admin';
  final String welcomeSub = 'Manage your workspace with ease and clarity.';
  final String phoneNumber = 'Phone Number';
  final String phoneHint = '+91 00000 00000';
  final String sendOtp = 'Send Verification Code';
  final String terms = 'By continuing, you agree to our Terms of Service';
  final String verifyIdentity = 'Verify Identity';
  final String otpSentTo = 'We have sent a 6-digit code to\n';
  final String resendOtp = 'Resend Verification Code';
  final String verifyAndContinue = 'Verify and Continue';
  final String loginSuccess = 'Login Successful';
  final String enterPhone = 'Please enter a phone number';
  final String enterOtp = 'Please enter a 6-digit OTP';
}

