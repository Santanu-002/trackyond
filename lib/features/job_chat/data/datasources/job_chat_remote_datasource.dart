import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/send_message_response_model.dart';

import 'package:trackyond/features/job_chat/data/models/message_query_options_model.dart';

abstract interface class IJobChatDataSource {
  Future<ApiResponse<List<JobChatMessageModel>>> getMessages({
    required String jobId,
    MessageQueryOptionsModel? options,
  });
  Future<ApiResponse<SendMessageResponseModel>> sendMessage({required List<JobChatMessageModel> messages});
  Future<ApiResponse<JobModel>> updateJobStatus({
    required String jobId,
    required String status,
  });
  Future<ApiResponse<List<MemberProfileModel>>> getChatMembers({required String jobId});
}

class JobChatRemoteDataSourceImpl with BaseRemoteDataSource implements IJobChatDataSource {
  final Dio _dio;

  JobChatRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<List<JobChatMessageModel>>> getMessages({
    required String jobId,
    MessageQueryOptionsModel? options,
  }) async {
    return performApiRequest(
      _dio.get(
        ApiEndpoints.common.jobChatMessages(jobId),
        queryParameters: options?.toQueryParams(),
      ),
      (data) {
        final list = data as List;
        return list.map((e) => JobChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Future<ApiResponse<SendMessageResponseModel>> sendMessage({required List<JobChatMessageModel> messages}) async {
    final payload = messages.map((m) => m.toJson()).toList();
    return performApiRequest(
      _dio.post(
        ApiEndpoints.common.jobChatMessages(messages.first.jobId),
        data: payload,
      ),
      (data) => SendMessageResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<JobModel>> updateJobStatus({
    required String jobId,
    required String status,
  }) async {
    return performApiRequest(
      _dio.patch(
        ApiEndpoints.employee.jobStatus(jobId),
        data: {'status': status},
      ),
      (data) => JobModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<MemberProfileModel>>> getChatMembers({required String jobId}) async {
    return performApiRequest(
      _dio.get(ApiEndpoints.common.jobChatMembers(jobId)),
      (data) {
        final list = data as List;
        return list.map((e) => MemberProfileModel.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }
}
