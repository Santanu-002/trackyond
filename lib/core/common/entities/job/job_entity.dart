import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/enums/job_status.dart';

class JobEntity extends Equatable {
  final String jobId;
  final String jobTitle;
  final String customerName;
  final String customerPhone;
  final String? customerAddress;
  final String workerProfileUid;
  final String? workerName;
  final String? workerImage;
  final String? createdByProfileUid;
  final String? createdByName;
  final JobStatus status;
  final bool requirePhotoOnStart;
  final bool requirePhotoOnComplete;
  final bool captureLocation;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const JobEntity({
    required this.jobId,
    required this.jobTitle,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress,
    required this.workerProfileUid,
    this.workerName,
    this.workerImage,
    this.createdByProfileUid,
    this.createdByName,
    required this.status,
    required this.requirePhotoOnStart,
    required this.requirePhotoOnComplete,
    required this.captureLocation,
    required this.createdAt,
    this.assignedAt,
    this.updatedAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        jobId,
        jobTitle,
        customerName,
        customerPhone,
        customerAddress,
        workerProfileUid,
        workerName,
        workerImage,
        createdByProfileUid,
        createdByName,
        status,
        requirePhotoOnStart,
        requirePhotoOnComplete,
        captureLocation,
        createdAt,
        assignedAt,
        updatedAt,
        completedAt,
      ];
}
