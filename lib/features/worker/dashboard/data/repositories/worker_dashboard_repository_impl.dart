import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/worker_dashboard_remote_data_source.dart';
import 'package:trackyond/features/worker/dashboard/data/models/dashboard/worker_dashboard_model.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/dashboard/worker_dashboard_data.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_worker_dashboard_repository.dart';

class WorkerDashboardRepositoryImpl implements IWorkerDashboardRepository {
  final IWorkerDashboardRemoteDataSource _dataSource;

  WorkerDashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, WorkerDashboardData>> getDashboardData() async {
    final ApiResponse<WorkerDashboardModel> result = await _dataSource.getDashboardData();
    return result.when(
      success: (success, message, model) => right(model!.toEntity()),
      error: (success, message, data, statusCode) => left(ServerFailure(message)),
    );
  }
}
