import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class UpdateUserDetailsUseCase
    implements BaseUseCase<Unit, UpdateUserDetailsParams> {
  final ICompanyRepository _repository;

  UpdateUserDetailsUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(UpdateUserDetailsParams params) async {
    return await _repository.updateUserDetails(
      profile: params.profile,
      isNewUser: params.isNewUser,
    );
  }
}

class UpdateUserDetailsParams {
  final MemberProfile profile;
  final bool isNewUser;

  UpdateUserDetailsParams({required this.profile, required this.isNewUser});
}
