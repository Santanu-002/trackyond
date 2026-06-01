import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class SendMessageResponseModel {
  final JobChatMessageModel message;
  final List<JobChatMessageModel> messages;
  final List<String> allowedActions;
  final JobModel? job;

  SendMessageResponseModel({
    required this.message,
    this.messages = const [],
    required this.allowedActions,
    this.job,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final jobData = json['job'] != null ? JobModel.fromJson(json['job'] as Map<String, dynamic>) : null;
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
      job: jobData,
    );
  }

  SendMessageResult toEntity() {
    return SendMessageResult(
      message: message.toEntity(),
      messages: messages.map((m) => m.toEntity()).toList(),
      allowedActions: allowedActions,
      job: job?.toEntity(),
    );
  }
}
