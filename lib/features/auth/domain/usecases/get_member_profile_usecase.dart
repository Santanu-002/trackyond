import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetMemberProfileUseCase {
  final IAuthRepository _repository;

  GetMemberProfileUseCase(this._repository);

  MemberProfile? execute() => _repository.memberProfile;
}
