import 'package:trackyond/core/common/entities/owner_profile/owner_profile.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetOwnerProfileUseCase {
  final IAuthRepository _repository;

  GetOwnerProfileUseCase(this._repository);

  OwnerProfile? execute() => _repository.ownerProfile;
}
