import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class SendMessageResponseModel {
  final JobChatMessageModel message;
  final List<String> allowedActions;

  SendMessageResponseModel({
    required this.message,
    required this.allowedActions,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      message: JobChatMessageModel.fromJson(json['message'] as Map<String, dynamic>),
      allowedActions: List<String>.from(json['allowedActions'] ?? []),
    );
  }

  SendMessageResult toEntity() {
    return SendMessageResult(
      message: message.toEntity(),
      allowedActions: allowedActions,
    );
  }
}
