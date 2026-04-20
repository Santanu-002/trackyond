import 'package:trackyond/core/common/entities/user/user_role.dart';

class User {
  final String uid;
  final String phone;
  final UserRole role;
  final bool isNewUser;

  User({
    required this.uid,
    required this.phone,
    required this.role,
    required this.isNewUser,
  });
}
