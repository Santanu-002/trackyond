import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/job/job_filter_options.dart';
import 'package:trackyond/core/common/entities/job/job_sort_options.dart';

abstract interface class IJobsRepository {
  Future<Either<AppFailure, JobEntity>> createJob(Map<String, dynamic> jobData);
  
  Future<Either<AppFailure, List<JobEntity>>> getJobs({
    int limit = 20,
    int offset = 0,
    JobFilterOptions? filter,
    JobSortOptions? sort,
  });
}
