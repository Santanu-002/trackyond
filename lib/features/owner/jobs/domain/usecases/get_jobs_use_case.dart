import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_entity.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';

class GetJobsParams {
  final int limit;
  final int offset;
  final String? status;
  final String? workerId;
  final String? orderBy;
  final String? order;

  GetJobsParams({
    this.limit = 20,
    this.offset = 0,
    this.status,
    this.workerId,
    this.orderBy,
    this.order,
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
      status: params.status,
      workerId: params.workerId,
      orderBy: params.orderBy,
      order: params.order,
    );
  }
}
