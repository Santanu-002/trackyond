import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/owner/dashboard/data/models/status_query_option/team_status_query_options_model.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_query_options.dart';

abstract interface class ITeamRemoteDataSource {
  Future<ApiResponse<MemberProfileModel>> addTeamMember({
    required String name,
    required String phone,
    required String companyUid,
    required String designation,
    String? gender,
    String? imagePath,
  });

  Future<ApiResponse<List<MemberProfileModel>>> getTeamMembers();
  Future<ApiResponse<CompanyModel>> getCompany();
  Future<ApiResponse<Map<String, dynamic>>> getTeamStatus({
    TeamStatusQueryOptions? options,
  });

  Future<ApiResponse<Map<String, dynamic>>> getMemberAttendanceLogs({
    required String uid,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    String? search,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortOrder,
  });

  Future<ApiResponse<String>> exportAttendanceLogs({
    required String uid,
    required String format,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    String? search,
  });

  Future<ApiResponse<MemberProfileModel>> editMemberProfile({
    required MemberProfileModel profile,
  });

  Future<ApiResponse<void>> markAsExEmployee({
    required String uid,
  });
}

class TeamRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements ITeamRemoteDataSource {
  final Dio _dio;

  TeamRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<CompanyModel>> getCompany() async {
    return performApiRequest(
      _dio.get(ApiEndpoints.admin.company),
      (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getTeamStatus({
    TeamStatusQueryOptions? options,
  }) async {
    final queryParameters = options != null
        ? TeamStatusQueryOptionsModel.fromEntity(options).toJson()
        : null;

    return performApiRequest(
      _dio.get(
        "${ApiEndpoints.admin.company}/team-status",
        queryParameters: queryParameters,
      ),
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<MemberProfileModel>> addTeamMember({
    required String name,
    required String phone,
    required String companyUid,
    required String designation,
    String? gender,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'memberName': name,
      'userPhoneNo': phone,
      'designation': designation,
      'gender': gender,
      'companyUid': companyUid,
    });

    if (imagePath != null) {
      formData.files.add(
        MapEntry('memberImage', await MultipartFile.fromFile(imagePath)),
      );
    }

    return performApiRequest(
      _dio.post(ApiEndpoints.admin.members, data: formData),
      (json) => MemberProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<MemberProfileModel>>> getTeamMembers() async {
    return performApiRequest(_dio.get(ApiEndpoints.admin.members), (json) {
      if (json is Map<String, dynamic> && json.containsKey('members')) {
        final members = json['members'] as List<dynamic>;

        return members
            .map<MemberProfileModel>((e) => MemberProfileModel.fromJson(e))
            .toList();
      }
      return <MemberProfileModel>[];
    });
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getMemberAttendanceLogs({
    required String uid,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    String? search,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortOrder,
  }) async {
    final queryParameters = {
      'accountUid': uid,
      if (fromDate != null) 'startDate': fromDate.toUtc().toIso8601String(),
      if (toDate != null) 'endDate': toDate.toUtc().toIso8601String(),
      'status': ?status,
      'search': ?search,
      'limit': ?limit,
      'offset': ?offset,
      'sortBy': ?sortBy,
      'sortOrder': ?sortOrder,
    };

    return performApiRequest(
      _dio.get(
        ApiEndpoints.admin.attendance,
        queryParameters: queryParameters,
      ),
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<MemberProfileModel>> editMemberProfile({
    required MemberProfileModel profile,
  }) async {
    // Mocking update
    return ApiResponse.success(
      success: true,
      message: 'Profile updated successfully',
      data: profile,
    );
  }

  @override
  Future<ApiResponse<String>> exportAttendanceLogs({
    required String uid,
    required String format,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    String? search,
  }) async {
    final queryParameters = {
      'accountUid': uid,
      if (fromDate != null) 'startDate': fromDate.toUtc().toIso8601String(),
      if (toDate != null) 'endDate': toDate.toUtc().toIso8601String(),
      'status': ?status,
      'search': ?search,
    };

    final url = format == 'csv'
        ? ApiEndpoints.admin.attendanceExportCsv
        : ApiEndpoints.admin.attendanceExportPdf;

    return performApiRequest(
      _dio.get(url, queryParameters: queryParameters),
      (json) => (json as Map<String, dynamic>)['fileUrl'] as String,
    );
  }

  @override
  Future<ApiResponse<void>> markAsExEmployee({
    required String uid,
  }) async {
    // Mocking action
    return ApiResponse.success(
      success: true,
      message: 'Member marked as ex-employee',
      data: null,
    );
  }
}
