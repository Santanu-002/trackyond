import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/attendance/data/data_sources/attendance_remote_data_source.dart';
import 'package:trackyond/features/worker/attendance/data/models/request/attendance_request_model.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_status_entity.dart';
import 'package:trackyond/features/worker/attendance/domain/repositories/i_attendance_repository.dart';

class AttendanceRepositoryImpl implements IAttendanceRepository {
  final IAttendanceRemoteDataSource _remoteDataSource;

  AttendanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, AttendanceEntity>> startAttendance({
    required String profileUid,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final request = AttendanceRequestModel(
      profileUid: profileUid,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
    final response = await _remoteDataSource.startAttendance(request);

    return response.when(
      success: (_, _, data) {
        if (data != null) return Right(data);
        return Left(ServerFailure('Data is null'));
      },
      error: (_, message, _, _) => Left(ServerFailure(message)),
    );
  }

  @override
  Future<Either<AppFailure, AttendanceEntity>> endAttendance({
    required String profileUid,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final request = AttendanceRequestModel(
      profileUid: profileUid,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
    final response = await _remoteDataSource.endAttendance(request);

    return response.when(
      success: (_, _, data) {
        if (data != null) return Right(data);
        return Left(ServerFailure('Data is null'));
      },
      error: (_, message, _, _) => Left(ServerFailure(message)),
    );
  }

  @override
  Future<Either<AppFailure, AttendanceStatusEntity>> getAttendanceStatus({
    required String profileUid,
  }) async {
    final response = await _remoteDataSource.getAttendanceStatus(profileUid);

    return response.when(
      success: (_, _, data) {
        if (data != null) return Right(data);
        return Left(ServerFailure('Data is null'));
      },
      error: (_, message, _, _) => Left(ServerFailure(message)),
    );
  }
}
