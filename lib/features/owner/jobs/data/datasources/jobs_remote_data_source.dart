import 'package:dio/dio.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/job_model.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_filter_options.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_sort_options.dart';
import 'package:trackyond/core/common/enums/job_status.dart';

abstract interface class IJobsRemoteDataSource {
  Future<ApiResponse<JobModel>> createJob(Map<String, dynamic> jobData);
  
  Future<ApiResponse<List<JobModel>>> getJobs({
    int limit = 20,
    int offset = 0,
    JobFilterOptions? filter,
    JobSortOptions? sort,
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
    JobFilterOptions? filter,
    JobSortOptions? sort,
  }) async {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'offset': offset,
    };

    if (filter != null) {
      if (filter.search != null && filter.search!.isNotEmpty) {
        queryParams['search'] = filter.search;
        queryParams['searchBy'] = filter.searchBy.value;
      }
      
      // Extract rules from advancedFilter for standard API params
      queryParams['logicalOperator'] = filter.advancedFilter.logicalOperator.name;
      
      for (final rule in filter.advancedFilter.rules) {
        if (rule.field == 'status' && rule.value is List) {
          queryParams['statuses'] = (rule.value as List).map((e) => (e as JobStatus).name).toList();
        } else if (rule.field == 'worker' && rule.value is List) {
          queryParams['workerIds'] = (rule.value as List).map((e) => (e as MemberProfile).accountUid).toList();
        } else if (rule.field == 'date' && rule.value is List && (rule.value as List).length == 2) {
          queryParams['fromDate'] = (rule.value as List)[0].toIso8601String();
          queryParams['toDate'] = (rule.value as List)[1].toIso8601String();
        }
      }
    }

    if (sort != null) {
      queryParams['orderBy'] = sort.field.value;
      queryParams['order'] = sort.order.value;
    }

    return performApiRequest(
      _dio.get(ApiEndpoints.admin.jobs, queryParameters: queryParams),
      (data) {
        final jobsList = (data as Map<String, dynamic>)['jobs'] as List;
        return jobsList.map((e) => JobModel.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }
}
