import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/user_role.dart';

class VerifyOtpEntity {
  final User user;
  final bool isNewUser;
  final UserRole role;

  VerifyOtpEntity({
    required this.user,
    required this.isNewUser,
    required this.role,
  });
}
