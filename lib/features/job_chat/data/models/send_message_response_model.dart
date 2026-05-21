import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class SendMessageResponseModel {
  final JobChatMessageModel message;
  final List<String> allowedActions;
  final JobModel? job;

  SendMessageResponseModel({
    required this.message,
    required this.allowedActions,
    this.job,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      message: JobChatMessageModel.fromJson(json['message'] as Map<String, dynamic>),
      allowedActions: List<String>.from(json['allowedActions'] ?? []),
      job: json['job'] != null ? JobModel.fromJson(json['job'] as Map<String, dynamic>) : null,
    );
  }

  SendMessageResult toEntity() {
    return SendMessageResult(
      message: message.toEntity(),
      allowedActions: allowedActions,
      job: job?.toEntity(),
    );
  }
}
