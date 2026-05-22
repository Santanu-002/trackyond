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
    required String workerProfileUid,
    String? workerName,
    String? workerImage,
    String? createdByProfileUid,
    String? createdByName,
    required String status,
    required bool requirePhotoOnStart,
    required bool requirePhotoOnComplete,
    required bool captureLocation,
    required DateTime createdAt,
    DateTime? assignedAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    @Default([]) List<String> allowedActions,
    String? lastMessage,
    DateTime? lastMessageAt,
    String? lastActivityType,
    String? lastActivityMessage,
    DateTime? lastActivityAt,
  }) = _JobModel;

  const JobModel._();

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  JobEntity toEntity() => JobEntity(
        jobId: jobId,
        jobTitle: jobTitle,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        workerProfileUid: workerProfileUid,
        workerName: workerName,
        workerImage: workerImage,
        createdByProfileUid: createdByProfileUid,
        createdByName: createdByName,
        status: JobStatus.fromString(status),
        requirePhotoOnStart: requirePhotoOnStart,
        requirePhotoOnComplete: requirePhotoOnComplete,
        captureLocation: captureLocation,
        createdAt: createdAt,
        assignedAt: assignedAt,
        updatedAt: updatedAt,
        completedAt: completedAt,
        allowedActions: allowedActions,
        lastMessage: lastMessage,
        lastMessageAt: lastMessageAt,
        lastActivityType: lastActivityType,
        lastActivityMessage: lastActivityMessage,
        lastActivityAt: lastActivityAt,
      );
}
