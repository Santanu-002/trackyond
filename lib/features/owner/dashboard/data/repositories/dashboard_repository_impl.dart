import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';
import 'package:trackyond/features/owner/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:trackyond/features/owner/dashboard/data/models/response/owner_dashboard_model.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final IDashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, OwnerDashboardData>> getOwnerDashboard() async {
    final ApiResponse<OwnerDashboardModel> response = await _remoteDataSource.getOwnerDashboard();
    return response.when(
      success: (success, message, model) => right(model!.toEntity()),
      error: (success, message, data, statusCode) => left(ServerFailure(message)),
    );
  }
}
