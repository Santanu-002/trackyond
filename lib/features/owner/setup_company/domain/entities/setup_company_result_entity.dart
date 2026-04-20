import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';

class SetupCompanyResultEntity extends Equatable {
  final CompanyEntity company;
  final MemberProfile memberProfile;

  const SetupCompanyResultEntity({
    required this.company,
    required this.memberProfile,
  });

  @override
  List<Object?> get props => [company, memberProfile];
}
