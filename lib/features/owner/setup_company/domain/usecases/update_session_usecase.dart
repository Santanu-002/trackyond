import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class UpdateSessionUseCase {
  final ICompanyRepository _repository;

  UpdateSessionUseCase(this._repository);

  Future<void> call({
    required MemberProfile profile,
    required bool isNewUser,
  }) {
    return _repository.updateSession(
      profile: profile,
      isNewUser: isNewUser,
    );
  }
}
