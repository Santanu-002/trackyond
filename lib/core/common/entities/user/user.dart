import 'package:trackyond/core/common/entities/user/user_role.dart';

class User {
  final String id;
  final String phone;
  final UserRole role;

  User({required this.id, required this.phone, required this.role});
}
