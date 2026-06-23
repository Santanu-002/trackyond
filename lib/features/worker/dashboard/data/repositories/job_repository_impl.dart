import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_local_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_remote_datasource.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';

class JobRepositoryImpl implements IJobRepository {
  final IJobRemoteDataSource _remoteDataSource;
  final IJobLocalDataSource _localDataSource;

  JobRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<AppFailure, List<JobEntity>>> getAssignedJobs({
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (isOnline) {
      final response = await _remoteDataSource.getAssignedJobs(
        limit: limit,
        offset: offset,
        status: status,
      );

      return response.when(
        success: (success, message, data) async {
          if (data != null) {
            await _localDataSource.saveJobs(data);
          }
          return right(data?.map((e) => e.toEntity()).toList() ?? []);
        },
        error: (success, message, data, statusCode) async {
          final cached = await _localDataSource.getCachedJobs(status: status);
          if (cached.isNotEmpty) {
            return right(cached.map((e) => e.toEntity()).toList());
          }
          return left(ServerFailure(message));
        },
      );
    } else {
      final cached = await _localDataSource.getCachedJobs(status: status);
      return right(cached.map((e) => e.toEntity()).toList());
    }
  }
}
