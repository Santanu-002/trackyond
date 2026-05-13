import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
sealed class JobModel with _$JobModel {
  const factory JobModel({
    required String jobId,
    required String jobTitle,
    required String customerName,
    required String customerPhone,
    String? customerAddress,
    required String workerAccountUid,
    String? workerName,
    String? workerImage,
    required String status,
    required bool requirePhotoOnStart,
    required bool requirePhotoOnComplete,
    required bool captureLocation,
    required DateTime createdAt,
    DateTime? assignedAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) = _JobModel;

  const JobModel._();

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  JobEntity toEntity() => JobEntity(
        jobId: jobId,
        jobTitle: jobTitle,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        workerAccountUid: workerAccountUid,
        workerName: workerName,
        workerImage: workerImage,
        status: JobStatus.fromString(status),
        requirePhotoOnStart: requirePhotoOnStart,
        requirePhotoOnComplete: requirePhotoOnComplete,
        captureLocation: captureLocation,
        createdAt: createdAt,
        assignedAt: assignedAt,
        updatedAt: updatedAt,
        completedAt: completedAt,
      );
}
