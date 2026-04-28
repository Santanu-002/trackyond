import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_entity.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_status_entity.dart';

abstract interface class IAttendanceRepository {
  Future<Either<AppFailure, AttendanceEntity>> startAttendance({
    required String accountUid,
    required double latitude,
    required double longitude,
    String? address,
  });

  Future<Either<AppFailure, AttendanceEntity>> endAttendance({
    required String accountUid,
    required double latitude,
    required double longitude,
    String? address,
  });

  Future<Either<AppFailure, AttendanceStatusEntity>> getAttendanceStatus({
    required String accountUid,
  });
}
