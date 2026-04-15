class AppMessages {
  static const SuccessMessages success = SuccessMessages();
  static const ErrorMessages error = ErrorMessages();
  static const AuthMessages auth = AuthMessages();
}

class SuccessMessages {
  const SuccessMessages();
  final String basic = 'Operation successful';
}

class ErrorMessages {
  const ErrorMessages();
  final String basic = 'An error occurred';
  final String network = 'Check your internet connection';
  final String validation = 'Please check your inputs';
}

class AuthMessages {
  const AuthMessages();
  final String invalidCredentials = 'Invalid email or password';
}
