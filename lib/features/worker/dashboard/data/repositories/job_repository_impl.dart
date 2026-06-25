import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/repositories/base_sync_repository.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_local_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_remote_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/sync/job_sync_queries.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';

class JobRepositoryImpl extends BaseSyncRepository implements IJobRepository {
  final IJobRemoteDataSource _remoteDataSource;
  final IJobLocalDataSource _localDataSource;

  JobRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<AppFailure, List<JobEntity>>> getAssignedJobs({
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    return syncData<List<JobEntity>, List<JobModel>>(
      query: GetAssignedJobsQuery(
        status: status,
        limit: limit,
        offset: offset,
      ),
      fetchLocal: () async {
        return await _localDataSource.getCachedJobs(status: status);
      },
      fetchRemote: () async {
        final response = await _remoteDataSource.getAssignedJobs(
          limit: limit,
          offset: offset,
          status: status,
        );
        return response.when(
          success: (success, message, data) => data ?? [],
          error: (success, message, data, statusCode) => throw Exception(message),
        );
      },
      updateLocal: (data) async {
        await _localDataSource.saveJobs(data);
      },
    );
  }

  @override
  Future<Either<AppFailure, Unit>> saveJobs(List<JobEntity> jobs) async {
    try {
      final models = jobs.map((e) => JobModel.fromEntity(e)).toList();
      await _localDataSource.saveJobs(models);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
