import 'package:trackyond/core/common/enums/user_role.dart';

class User {
  final String uid;
  final String phone;
  final UserRole role;
  final bool isNewUser;
  final String? primaryProfileUid;

  User({
    required this.uid,
    required this.phone,
    required this.role,
    required this.isNewUser,
    this.primaryProfileUid,
  });
}
