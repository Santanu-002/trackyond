import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_entity.dart';

abstract interface class IJobsRepository {
  Future<Either<AppFailure, JobEntity>> createJob(Map<String, dynamic> jobData);
  Future<Either<AppFailure, List<JobEntity>>> getJobs({
    int limit = 20,
    int offset = 0,
    String? status,
    String? workerId,
    String? orderBy,
    String? order,
  });
}
