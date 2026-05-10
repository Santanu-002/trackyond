import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_entity.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
sealed class JobModel with _$JobModel {
  const factory JobModel({
    required String jobId,
    required String title,
    required String customerName,
    required String customerPhone,
    String? customerAddress,
    String? workerAccountUid,
    required String status,
    required bool requirePhotoOnStart,
    required bool requirePhotoOnComplete,
    required bool captureLocation,
    required String createdAt,
    String? assignedAt,
  }) = _JobModel;

  const JobModel._();

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  JobEntity toEntity() => JobEntity(
        jobId: jobId,
        title: title,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        workerAccountUid: workerAccountUid,
        status: status,
        requirePhotoOnStart: requirePhotoOnStart,
        requirePhotoOnComplete: requirePhotoOnComplete,
        captureLocation: captureLocation,
        createdAt: DateTime.parse(createdAt),
        assignedAt: assignedAt != null ? DateTime.parse(assignedAt!) : null,
      );
}
