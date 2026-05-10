import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';
import 'package:trackyond/features/owner/dashboard/domain/repositories/i_dashboard_repository.dart';

class GetOwnerDashboardUseCase implements BaseUseCase<OwnerDashboardData, NoParams> {
  final IDashboardRepository _repository;

  GetOwnerDashboardUseCase(this._repository);

  @override
  Future<Either<AppFailure, OwnerDashboardData>> call(NoParams params) async {
    return await _repository.getOwnerDashboard();
  }
}
