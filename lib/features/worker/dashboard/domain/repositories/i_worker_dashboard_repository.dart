import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/dashboard/worker_dashboard_data.dart';

abstract interface class IWorkerDashboardRepository {
  Future<Either<AppFailure, WorkerDashboardData>> getDashboardData();
}
