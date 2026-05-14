import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract interface class BaseUseCase<SuccessType, Params> {
  Future<Either<AppFailure, SuccessType>> call(Params params);
}

class NoParams {
  const NoParams();
}
