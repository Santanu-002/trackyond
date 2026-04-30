import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/user_role.dart';

class VerifyOtpEntity {
  final User user;
  final bool isNewUser;
  final UserRole role;
  final MemberProfile? profile;
  final CompanyEntity? company;

  VerifyOtpEntity({
    required this.user,
    required this.isNewUser,
    required this.role,
    this.profile,
    this.company,
  });
}
