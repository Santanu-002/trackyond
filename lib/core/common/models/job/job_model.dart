import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/services/database/tables/job_table.dart';

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
    required List<String> allowedActions,
    String? lastMessage,
    DateTime? lastMessageAt,
    String? lastActivityType,
    String? lastActivityMessage,
    DateTime? lastActivityAt,
  }) = _JobModel;

  const JobModel._();

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  Map<String, dynamic> toDbMap() {
    return {
      JobTable.columnNames.jobId: jobId,
      JobTable.columnNames.jobTitle: jobTitle,
      JobTable.columnNames.customerName: customerName,
      JobTable.columnNames.customerPhone: customerPhone,
      JobTable.columnNames.customerAddress: customerAddress,
      JobTable.columnNames.workerProfileUid: workerProfileUid,
      JobTable.columnNames.workerName: workerName,
      JobTable.columnNames.workerImage: workerImage,
      JobTable.columnNames.createdByProfileUid: createdByProfileUid,
      JobTable.columnNames.createdByName: createdByName,
      JobTable.columnNames.jobStatus: status,
      JobTable.columnNames.requirePhotoOnStart: requirePhotoOnStart ? 1 : 0,
      JobTable.columnNames.requirePhotoOnComplete: requirePhotoOnComplete ? 1 : 0,
      JobTable.columnNames.captureLocation: captureLocation ? 1 : 0,
      JobTable.columnNames.createdAt: createdAt.toUtc().toIso8601String(),
      JobTable.columnNames.assignedAt: assignedAt?.toUtc().toIso8601String(),
      JobTable.columnNames.updatedAt: updatedAt?.toUtc().toIso8601String(),
      JobTable.columnNames.completedAt: completedAt?.toUtc().toIso8601String(),
      JobTable.columnNames.allowedActions: jsonEncode(allowedActions),
      JobTable.columnNames.lastMessage: lastMessage,
      JobTable.columnNames.lastMessageAt: lastMessageAt?.toUtc().toIso8601String(),
      JobTable.columnNames.lastActivityType: lastActivityType,
      JobTable.columnNames.lastActivityMessage: lastActivityMessage,
      JobTable.columnNames.lastActivityAt: lastActivityAt?.toUtc().toIso8601String(),
    };
  }

  factory JobModel.fromDbMap(Map<String, dynamic> map) {
    return JobModel(
      jobId: map[JobTable.columnNames.jobId] as String,
      jobTitle: map[JobTable.columnNames.jobTitle] as String,
      customerName: map[JobTable.columnNames.customerName] as String,
      customerPhone: map[JobTable.columnNames.customerPhone] as String,
      customerAddress: map[JobTable.columnNames.customerAddress] as String?,
      workerProfileUid: map[JobTable.columnNames.workerProfileUid] as String,
      workerName: map[JobTable.columnNames.workerName] as String?,
      workerImage: map[JobTable.columnNames.workerImage] as String?,
      createdByProfileUid: map[JobTable.columnNames.createdByProfileUid] as String?,
      createdByName: map[JobTable.columnNames.createdByName] as String?,
      status: map[JobTable.columnNames.jobStatus] as String,
      requirePhotoOnStart: (map[JobTable.columnNames.requirePhotoOnStart] as int) == 1,
      requirePhotoOnComplete: (map[JobTable.columnNames.requirePhotoOnComplete] as int) == 1,
      captureLocation: (map[JobTable.columnNames.captureLocation] as int) == 1,
      createdAt: DateTime.parse(map[JobTable.columnNames.createdAt] as String).toLocal(),
      assignedAt: map[JobTable.columnNames.assignedAt] != null
          ? DateTime.parse(map[JobTable.columnNames.assignedAt] as String).toLocal()
          : null,
      updatedAt: map[JobTable.columnNames.updatedAt] != null
          ? DateTime.parse(map[JobTable.columnNames.updatedAt] as String).toLocal()
          : null,
      completedAt: map[JobTable.columnNames.completedAt] != null
          ? DateTime.parse(map[JobTable.columnNames.completedAt] as String).toLocal()
          : null,
      allowedActions: List<String>.from(
        jsonDecode(map[JobTable.columnNames.allowedActions] as String? ?? '[]'),
      ),
      lastMessage: map[JobTable.columnNames.lastMessage] as String?,
      lastMessageAt: map[JobTable.columnNames.lastMessageAt] != null
          ? DateTime.parse(map[JobTable.columnNames.lastMessageAt] as String).toLocal()
          : null,
      lastActivityType: map[JobTable.columnNames.lastActivityType] as String?,
      lastActivityMessage: map[JobTable.columnNames.lastActivityMessage] as String?,
      lastActivityAt: map[JobTable.columnNames.lastActivityAt] != null
          ? DateTime.parse(map[JobTable.columnNames.lastActivityAt] as String).toLocal()
          : null,
    );
  }

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
