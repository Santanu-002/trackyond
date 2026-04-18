import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetUserRoleUseCase {
  final IAuthRepository _repository;

  GetUserRoleUseCase(this._repository);

  UserRole? execute() => _repository.userRole;
}
