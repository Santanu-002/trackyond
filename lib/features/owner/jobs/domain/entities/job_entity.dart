import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  final String jobId;
  final String title;
  final String customerName;
  final String customerPhone;
  final String? customerAddress;
  final String? workerAccountUid;
  final String status;
  final bool requirePhotoOnStart;
  final bool requirePhotoOnComplete;
  final bool captureLocation;
  final DateTime createdAt;
  final DateTime? assignedAt;

  const JobEntity({
    required this.jobId,
    required this.title,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress,
    this.workerAccountUid,
    required this.status,
    required this.requirePhotoOnStart,
    required this.requirePhotoOnComplete,
    required this.captureLocation,
    required this.createdAt,
    this.assignedAt,
  });

  @override
  List<Object?> get props => [
        jobId,
        title,
        customerName,
        customerPhone,
        customerAddress,
        workerAccountUid,
        status,
        requirePhotoOnStart,
        requirePhotoOnComplete,
        captureLocation,
        createdAt,
        assignedAt,
      ];
}
