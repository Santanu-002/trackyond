import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract interface class IJobRepository {
  Future<Either<AppFailure, List<JobEntity>>> getAssignedJobs({
    int limit = 20,
    int offset = 0,
    String? status,
  });
}
