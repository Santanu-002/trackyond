import 'package:trackyond/core/common/enums/gender.dart';

class MemberProfile {
  final String accountUid;
  final String userUid;
  final String name;
  final String phone;
  final String designation;
  final Gender? gender;
  final String? image;

  final String? companyUid;
  final String? createdBy;

  const MemberProfile({
    required this.accountUid,
    required this.userUid,
    required this.name,
    required this.phone,
    required this.designation,
    this.gender,
    this.image,
    this.companyUid,
    this.createdBy,
  });
}
