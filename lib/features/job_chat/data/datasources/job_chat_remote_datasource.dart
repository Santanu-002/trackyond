import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';

abstract interface class IJobChatDataSource {
  Future<ApiResponse<List<JobChatMessageModel>>> getMessages({required String jobId});
  Future<ApiResponse<JobChatMessageModel>> sendMessage({required JobChatMessageModel message});
}

class JobChatRemoteDataSourceImpl with BaseRemoteDataSource implements IJobChatDataSource {
  final Dio _dio;

  JobChatRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<List<JobChatMessageModel>>> getMessages({required String jobId}) async {
    return performApiRequest(
      _dio.get(ApiEndpoints.common.jobChatMessages(jobId)),
      (data) {
        final list = data as List;
        return list.map((e) => JobChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Future<ApiResponse<JobChatMessageModel>> sendMessage({required JobChatMessageModel message}) async {
    return performApiRequest(
      _dio.post(
        ApiEndpoints.common.jobChatMessages(message.jobId),
        data: message.toJson(),
      ),
      (data) => JobChatMessageModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
