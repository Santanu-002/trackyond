import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetAuthenticatedUserUseCase implements BaseUseCase<User?, NoParams> {
  final IAuthRepository _repository;

  GetAuthenticatedUserUseCase(this._repository);

  @override
  Future<Either<AppFailure, User?>> call(NoParams params) async {
    return await _repository.getAuthenticatedUser();
  }
}
