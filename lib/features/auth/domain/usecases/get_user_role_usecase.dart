import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetUserRoleUseCase implements BaseUseCase<UserRole?, NoParams> {
  final IAuthRepository _repository;

  GetUserRoleUseCase(this._repository);

  @override
  Future<Either<AppFailure, UserRole?>> call(NoParams params) async {
    return await _repository.getUserRole();
  }
}
