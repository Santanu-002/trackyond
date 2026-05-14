import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class LogoutUseCase implements BaseUseCase<Unit, NoParams> {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(NoParams params) async {
    return await _repository.logout();
  }
}
