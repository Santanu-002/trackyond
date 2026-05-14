import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/repositories/attendance_repository.dart';

class EndAttendanceUseCase
    implements BaseUseCase<AttendanceEntity, EndAttendanceParams> {
  final IAttendanceRepository _repository;

  EndAttendanceUseCase(this._repository);

  @override
  Future<Either<AppFailure, AttendanceEntity>> call(
    EndAttendanceParams params,
  ) {
    return _repository.endAttendance(
      profileUid: params.profileUid,
      latitude: params.latitude,
      longitude: params.longitude,
      address: params.address,
    );
  }
}

class EndAttendanceParams {
  final String profileUid;
  final double latitude;
  final double longitude;
  final String? address;

  EndAttendanceParams({
    required this.profileUid,
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
