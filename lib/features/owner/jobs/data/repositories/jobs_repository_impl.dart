import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';
import 'package:trackyond/core/common/entities/job/job_filter_options.dart';
import 'package:trackyond/core/common/entities/job/job_sort_options.dart';

class JobsRepositoryImpl implements IJobsRepository {
  final IJobsRemoteDataSource _remoteDataSource;

  JobsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, JobEntity>> createJob(
    Map<String, dynamic> jobData,
  ) async {
    final ApiResponse<dynamic> response = await _remoteDataSource.createJob(jobData);
    return response.when(
      success: (_, _, model) => right(model),
      error: (_, message, _, _) => left(ServerFailure(message)),
    );
  }

  @override
  Future<Either<AppFailure, List<JobEntity>>> getJobs({
    int limit = 20,
    int offset = 0,
    JobFilterOptions? filter,
    JobSortOptions? sort,
  }) async {
    final response = await _remoteDataSource.getJobs(
      limit: limit,
      offset: offset,
      filter: filter,
      sort: sort,
    );
    return response.when(
      success: (_, _, models) => right(models ?? []),
      error: (_, message, _, _) => left(ServerFailure(message)),
    );
  }
}
