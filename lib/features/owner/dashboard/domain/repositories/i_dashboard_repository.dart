import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';

abstract interface class IDashboardRepository {
  Future<Either<AppFailure, OwnerDashboardData>> getOwnerDashboard();
}
