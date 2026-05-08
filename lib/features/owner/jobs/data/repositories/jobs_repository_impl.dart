import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_entity.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';

class JobsRepositoryImpl implements IJobsRepository {
  final IJobsRemoteDataSource _remoteDataSource;

  JobsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, JobEntity>> createJob(
    Map<String, dynamic> jobData,
  ) async {
    final ApiResponse response = await _remoteDataSource.createJob(jobData);
    return response.when(
      success: (_, _, model) => right(model!.toEntity()),
      error: (_, message, _, _) => left(ServerFailure(message)),
    );
  }

  @override
  Future<Either<AppFailure, List<JobEntity>>> getJobs({
    int limit = 20,
    int offset = 0,
    String? status,
    String? workerId,
    String? orderBy,
    String? order,
  }) async {
    final response = await _remoteDataSource.getJobs(
      limit: limit,
      offset: offset,
      status: status,
      workerId: workerId,
      orderBy: orderBy,
      order: order,
    );
    return response.when(
      success: (_, _, models) =>
          right(models!.map((e) => e.toEntity()).toList()),
      error: (_, message, _, _) => left(ServerFailure(message)),
    );
  }
}
