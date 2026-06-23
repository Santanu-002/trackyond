import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/worker/dashboard/data/models/dashboard/worker_dashboard_model.dart';

abstract interface class IWorkerDashboardRemoteDataSource {
  Future<ApiResponse<WorkerDashboardModel>> getDashboardData();
  Future<ApiResponse<void>> triggerMockJobNotification();
}

class WorkerDashboardRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements IWorkerDashboardRemoteDataSource {
  final Dio _dio;

  WorkerDashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<WorkerDashboardModel>> getDashboardData() {
    return performApiRequest(
      _dio.get(ApiEndpoints.employee.dashboard),
      (data) => WorkerDashboardModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> triggerMockJobNotification() {
    return performApiRequest(
      _dio.post(ApiEndpoints.employee.jobsMock),
      (data) {},
    );
  }
}
