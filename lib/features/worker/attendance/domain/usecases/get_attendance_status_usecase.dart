import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_status_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/attendance/domain/repositories/i_attendance_repository.dart';

class GetAttendanceStatusUseCase
    implements BaseUseCase<AttendanceStatusEntity, GetAttendanceStatusParams> {
  final IAttendanceRepository _repository;

  GetAttendanceStatusUseCase(this._repository);

  @override
  Future<Either<AppFailure, AttendanceStatusEntity>> call(
    GetAttendanceStatusParams params,
  ) {
    return _repository.getAttendanceStatus(profileUid: params.profileUid);
  }
}

class GetAttendanceStatusParams {
  final String profileUid;

  GetAttendanceStatusParams({required this.profileUid});
}
