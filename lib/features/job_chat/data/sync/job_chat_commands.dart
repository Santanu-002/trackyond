import 'package:trackyond/core/services/sync/models/sync_command.dart';
import 'package:trackyond/features/job_chat/data/models/request/send_message_model.dart';

class SendMessageCommand extends SyncCommand {
  final String jobId;
  final List<SendMessageModel> messages;

  const SendMessageCommand({
    required this.jobId,
    required this.messages,
  });

  @override
  String get actionType => 'send_message';

  @override
  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  @override
  String? get requestId => messages.isEmpty ? null : messages.first.localUid;

  factory SendMessageCommand.fromJson(Map<String, dynamic> json) {
    return SendMessageCommand(
      jobId: json['jobId'] as String,
      messages: (json['messages'] as List)
          .map((m) => SendMessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DeleteMessagesCommand extends SyncCommand {
  final String jobId;
  final String deleteType;
  final List<String> messageUids;
  final DateTime deletedByUserAt;

  const DeleteMessagesCommand({
    required this.jobId,
    required this.deleteType,
    required this.messageUids,
    required this.deletedByUserAt,
  });

  @override
  String get actionType => 'delete_messages';

  @override
  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'deleteType': deleteType,
        'messageUids': messageUids,
        'deletedByUserAt': deletedByUserAt.toIso8601String(),
      };

  @override
  String? get requestId => messageUids.isEmpty ? null : messageUids.first;

  factory DeleteMessagesCommand.fromJson(Map<String, dynamic> json) {
    return DeleteMessagesCommand(
      jobId: json['jobId'] as String,
      deleteType: json['deleteType'] as String,
      messageUids: List<String>.from(json['messageUids'] as List),
      deletedByUserAt: DateTime.parse(json['deletedByUserAt'] as String),
    );
  }
}

class SeenMessagesCommand extends SyncCommand {
  final String jobId;
  final List<String>? messageUids;

  const SeenMessagesCommand({
    required this.jobId,
    this.messageUids,
  });

  @override
  String get actionType => 'seen_messages';

  @override
  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        if (messageUids != null) 'messageUids': messageUids,
      };

  @override
  String? get requestId => (messageUids == null || messageUids!.isEmpty) ? null : messageUids!.first;

  factory SeenMessagesCommand.fromJson(Map<String, dynamic> json) {
    return SeenMessagesCommand(
      jobId: json['jobId'] as String,
      messageUids: json['messageUids'] != null
          ? List<String>.from(json['messageUids'] as List)
          : null,
    );
  }
}

class DeliveredMessagesCommand extends SyncCommand {
  final String jobId;
  final List<String> messageUids;

  const DeliveredMessagesCommand({
    required this.jobId,
    required this.messageUids,
  });

  @override
  String get actionType => 'delivered_messages';

  @override
  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'messageUids': messageUids,
      };

  @override
  String? get requestId => messageUids.isEmpty ? null : messageUids.first;

  factory DeliveredMessagesCommand.fromJson(Map<String, dynamic> json) {
    return DeliveredMessagesCommand(
      jobId: json['jobId'] as String,
      messageUids: List<String>.from(json['messageUids'] as List),
    );
  }
}

class UpdateJobStatusCommand extends SyncCommand {
  final String jobId;
  final String status;

  const UpdateJobStatusCommand({
    required this.jobId,
    required this.status,
  });

  @override
  String get actionType => 'update_job_status';

  @override
  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'status': status,
      };

  factory UpdateJobStatusCommand.fromJson(Map<String, dynamic> json) {
    return UpdateJobStatusCommand(
      jobId: json['jobId'] as String,
      status: json['status'] as String,
    );
  }
}
