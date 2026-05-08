import 'package:dio/dio.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/features/owner/jobs/data/models/job_model.dart';

abstract interface class IJobsRemoteDataSource {
  Future<ApiResponse<JobModel>> createJob(Map<String, dynamic> jobData);
  Future<ApiResponse<List<JobModel>>> getJobs({
    int limit = 20,
    int offset = 0,
    String? status,
    String? workerId,
    String? orderBy,
    String? order,
  });
}

class JobsRemoteDataSourceImpl with BaseRemoteDataSource implements IJobsRemoteDataSource {
  final Dio _dio;

  JobsRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<JobModel>> createJob(Map<String, dynamic> jobData) async {
    return performApiRequest(
      _dio.post(ApiEndpoints.admin.jobs, data: jobData),
      (data) => JobModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<JobModel>>> getJobs({
    int limit = 20,
    int offset = 0,
    String? status,
    String? workerId,
    String? orderBy,
    String? order,
  }) async {
    final queryParams = {
      'limit': limit,
      'offset': offset,
      'status': ?status,
      'workerId': ?workerId,
      'orderBy': ?orderBy,
      'order': ?order,
    };

    return performApiRequest(
      _dio.get(ApiEndpoints.admin.jobs, queryParameters: queryParams),
      (data) => ((data as Map<String, dynamic>)['jobs'] as List).map((e) => JobModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
