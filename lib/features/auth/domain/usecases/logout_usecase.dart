import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> execute() => _repository.logout();
}
