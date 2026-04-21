import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class CheckAuthStatusUseCase implements BaseUseCase<bool, NoParams> {
  final IAuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  @override
  Future<Either<AppFailure, bool>> call(NoParams params) async {
    return await _repository.checkAuthStatus();
  }
}
