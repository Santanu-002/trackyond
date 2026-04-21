import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';

abstract class TeamRemoteDataSource {
  Future<ApiResponse<dynamic>> addTeamMember({
    required String name,
    required String phone,
  });
}

class TeamRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements TeamRemoteDataSource {
  final Dio _dio;

  TeamRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<dynamic>> addTeamMember({
    required String name,
    required String phone,
  }) async {
    return performApiRequest(
      _dio.post(
        ApiEndpoints.admin.members,
        data: {
          'memberName': name,
          'memberPhoneNo': phone,
        },
      ),
      (json) => json, // Returning raw json for now or handle parsing if needed
    );
  }
}
