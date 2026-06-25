import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/attendance/domain/repositories/i_attendance_repository.dart';

class StartAttendanceUseCase
    implements BaseUseCase<AttendanceEntity, StartAttendanceParams> {
  final IAttendanceRepository _repository;

  StartAttendanceUseCase(this._repository);

  @override
  Future<Either<AppFailure, AttendanceEntity>> call(
    StartAttendanceParams params,
  ) {
    return _repository.startAttendance(
      profileUid: params.profileUid,
      latitude: params.latitude,
      longitude: params.longitude,
      address: params.address,
    );
  }
}

class StartAttendanceParams {
  final String profileUid;
  final double latitude;
  final double longitude;
  final String? address;

  StartAttendanceParams({
    required this.profileUid,
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
