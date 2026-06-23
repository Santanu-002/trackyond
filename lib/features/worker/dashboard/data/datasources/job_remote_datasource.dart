import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';

abstract interface class IJobRemoteDataSource {
  Future<ApiResponse<List<JobModel>>> getAssignedJobs({
    int limit = 20,
    int offset = 0,
    String? status,
  });
}

class JobRemoteDataSourceImpl with BaseRemoteDataSource implements IJobRemoteDataSource {
  final Dio _dio;

  JobRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<List<JobModel>>> getAssignedJobs({
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    return performApiRequest(
      _dio.get(
        ApiEndpoints.employee.jobs,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'status': status,
        },
      ),
      (json) {
        final data = json as Map<String, dynamic>;
        final List<dynamic>? jobsList = data['jobs'] as List<dynamic>?;
        return jobsList
            ?.map((e) => JobModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
      },
    );
  }
}
