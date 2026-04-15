class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const AuthEndpoints auth = AuthEndpoints();
  static const UserEndpoints user = UserEndpoints();
}

class AuthEndpoints {
  const AuthEndpoints();
  static const String _root = '/auth';
  final String login = '$_root/login';
  final String register = '$_root/register';
}

class UserEndpoints {
  const UserEndpoints();
  static const String _root = '/user';
  final String profile = '$_root/profile';
}
