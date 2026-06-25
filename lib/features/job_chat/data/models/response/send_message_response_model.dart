import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

part 'send_message_response_model.freezed.dart';

@freezed
sealed class SendMessageResponseModel with _$SendMessageResponseModel implements SendMessageResult {
  const factory SendMessageResponseModel({
    required JobChatMessageModel message,
    @Default([]) List<JobChatMessageModel> messages,
    required List<String> allowedActions,
    @JsonKey(name: 'job') JobModel? jobModel,
  }) = _SendMessageResponseModel;

  const SendMessageResponseModel._();

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final jobData = json['job'] != null 
        ? JobModel.fromJson(json['job'] as Map<String, dynamic>) 
        : null;
    final messagesList = json['messages'] != null
        ? (json['messages'] as List)
            .map((e) => JobChatMessageModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <JobChatMessageModel>[];
    
    return SendMessageResponseModel(
      message: json['message'] != null
          ? JobChatMessageModel.fromJson(json['message'] as Map<String, dynamic>)
          : (messagesList.isNotEmpty ? messagesList.last : throw Exception('No message data found')),
      messages: messagesList,
      allowedActions: List<String>.from(json['allowedActions'] ?? jobData?.allowedActions ?? []),
      jobModel: jobData,
    );
  }

  @override
  JobEntity? get job => jobModel;
}
