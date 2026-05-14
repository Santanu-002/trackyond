import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetMemberProfileUseCase implements BaseUseCase<MemberProfile?, NoParams> {
  final IAuthRepository _repository;

  GetMemberProfileUseCase(this._repository);

  @override
  Future<Either<AppFailure, MemberProfile?>> call(NoParams params) async {
    return await _repository.getMemberProfile();
  }
}
