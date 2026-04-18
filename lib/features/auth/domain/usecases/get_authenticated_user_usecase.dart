import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetAuthenticatedUserUseCase {
  final IAuthRepository _repository;

  GetAuthenticatedUserUseCase(this._repository);

  User? execute() => _repository.currentUser;
}
