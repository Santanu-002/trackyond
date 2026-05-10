import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/owner/team_status/data/models/status/team_status_model.dart';

abstract interface class ITeamStatusDataSource {
  Future<ApiResponse<TeamStatusModel>> getTeamStatus({
    String? statusFilter,
    String? order,
    int? limit,
  });
}

class TeamStatusDataSourceImpl
    with BaseRemoteDataSource
    implements ITeamStatusDataSource {
  final Dio _dio;

  TeamStatusDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<TeamStatusModel>> getTeamStatus({
    String? statusFilter,
    String? order,
    int? limit,
  }) async {
    return performApiRequest(
      _dio.get(
        ApiEndpoints.admin.teamStatus,
        queryParameters: {
          'status_filter': statusFilter,
          'order': order,
          'limit': limit,
        },
      ),
      (json) => TeamStatusModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

