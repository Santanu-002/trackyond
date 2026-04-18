import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class CheckAuthStatusUseCase {
  final IAuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  bool execute() => _repository.isAuthenticated;
}
