import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';

class CreateJobParams {
  final String title;
  final String? description;
  final String customerName;
  final String customerPhone;
  final String? customerAddress;
  final String workerProfileUid;
  final bool requirePhotoOnStart;
  final bool requirePhotoOnComplete;
  final bool captureLocation;

  CreateJobParams({
    required this.title,
    this.description,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress,
    required this.workerProfileUid,
    this.requirePhotoOnStart = false,
    this.requirePhotoOnComplete = false,
    this.captureLocation = true,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerAddress': customerAddress,
    'workerProfileUid': workerProfileUid,
    'requirePhotoOnStart': requirePhotoOnStart,
    'requirePhotoOnComplete': requirePhotoOnComplete,
    'captureLocation': captureLocation,
  };
}

class CreateJobUseCase implements BaseUseCase<JobEntity, CreateJobParams> {
  final IJobsRepository _repository;

  CreateJobUseCase(this._repository);

  @override
  Future<Either<AppFailure, JobEntity>> call(CreateJobParams params) {
    return _repository.createJob(params.toJson());
  }
}
