import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';

class SaveJobsUseCase implements BaseUseCase<Unit, List<JobEntity>> {
  final IJobRepository _repository;

  SaveJobsUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(List<JobEntity> params) async {
    return await _repository.saveJobs(params);
  }
}
