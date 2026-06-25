import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_status_entity.dart';

abstract interface class IAttendanceRepository {
  Future<Either<AppFailure, AttendanceEntity>> startAttendance({
    required String profileUid,
    required double latitude,
    required double longitude,
    String? address,
  });

  Future<Either<AppFailure, AttendanceEntity>> endAttendance({
    required String profileUid,
    required double latitude,
    required double longitude,
    String? address,
  });

  Future<Either<AppFailure, AttendanceStatusEntity>> getAttendanceStatus({
    required String profileUid,
  });
}
