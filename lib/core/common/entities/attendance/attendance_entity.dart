import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';


class AttendanceEntity extends Equatable {
  final int id;
  final AttendanceStatus status;
  final DateTime startAt;
  final DateTime? endAt;
  final double? workHours;
  final String? startAddress;
  final String? endAddress;

  const AttendanceEntity({
    required this.id,
    required this.status,
    required this.startAt,
    this.endAt,
    this.workHours,
    this.startAddress,
    this.endAddress,
  });

  @override
  List<Object?> get props => [
    id,
    status,
    startAt,
    endAt,
    workHours,
    startAddress,
    endAddress,
  ];
}
