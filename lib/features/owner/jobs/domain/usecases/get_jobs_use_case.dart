import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';
import 'package:trackyond/core/common/entities/job/job_filter_options.dart';
import 'package:trackyond/core/common/entities/job/job_sort_options.dart';

class GetJobsParams {
  final int limit;
  final int offset;
  final JobFilterOptions? filter;
  final JobSortOptions? sort;

  GetJobsParams({
    this.limit = 20,
    this.offset = 0,
    this.filter,
    this.sort,
  });
}

class GetJobsUseCase implements BaseUseCase<List<JobEntity>, GetJobsParams> {
  final IJobsRepository _repository;

  GetJobsUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<JobEntity>>> call(GetJobsParams params) {
    return _repository.getJobs(
      limit: params.limit,
      offset: params.offset,
      filter: params.filter,
      sort: params.sort,
    );
  }
}
