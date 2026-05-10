import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/owner/dashboard/data/models/owner_dashboard_model.dart';

abstract interface class IDashboardRemoteDataSource {
  Future<ApiResponse<OwnerDashboardModel>> getOwnerDashboard();
}

class DashboardRemoteDataSourceImpl with BaseRemoteDataSource implements IDashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<OwnerDashboardModel>> getOwnerDashboard() async {
    return await performApiRequest(
      _dio.get(ApiEndpoints.admin.dashboard),
      (json) => OwnerDashboardModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
