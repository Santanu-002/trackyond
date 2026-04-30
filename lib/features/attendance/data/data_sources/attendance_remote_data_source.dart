import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/attendance/data/models/attendace/attendance_model.dart';
import 'package:trackyond/features/attendance/data/models/attendance_request/attendance_request_model.dart';
import 'package:trackyond/features/attendance/data/models/attendance_status/attendance_status_model.dart';

abstract interface class IAttendanceRemoteDataSource {
  Future<ApiResponse<AttendanceModel>> startAttendance(
    AttendanceRequestModel request,
  );

  Future<ApiResponse<AttendanceModel>> endAttendance(
    AttendanceRequestModel request,
  );

  Future<ApiResponse<AttendanceStatusModel>> getAttendanceStatus(
    String accountUid,
  );
}

class AttendanceRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements IAttendanceRemoteDataSource {
  final Dio _dio;

  AttendanceRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<AttendanceModel>> startAttendance(
    AttendanceRequestModel request,
  ) {
    return performApiRequest(
      _dio.post(ApiEndpoints.employee.attendanceStart, data: request.toJson()),
      (json) => AttendanceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<AttendanceModel>> endAttendance(
    AttendanceRequestModel request,
  ) {
    return performApiRequest(
      _dio.post(ApiEndpoints.employee.attendanceEnd, data: request.toJson()),

      (json) => AttendanceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<AttendanceStatusModel>> getAttendanceStatus(
    String accountUid,
  ) {
    return performApiRequest(
      _dio.get(
        ApiEndpoints.employee.attendanceStatus,
        queryParameters: {'account_uid': accountUid},
      ),
      (json) => AttendanceStatusModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

// Add this extension to _EmployeeEndpoints in ApiEndpoints if it's not there
// Or just use the string for now.
// Actually, I'll update ApiEndpoints.dart to add attendanceMark.
