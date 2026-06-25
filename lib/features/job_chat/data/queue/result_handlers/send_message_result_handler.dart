import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/result_handler/queue_task_result_handler.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/events/chat_event.dart';

class SendMessageResultHandler implements TaskResultHandler {
  final IJobChatLocalDataSource _localDataSource;
  final IEventBusRepository _eventBus;

  SendMessageResultHandler({
    required IJobChatLocalDataSource localDataSource,
    required IEventBusRepository eventBus,
  })  : _localDataSource = localDataSource,
        _eventBus = eventBus;

  @override
  QueueTaskType get type => QueueTaskType.sendMessage;

  @override
  Future<void> handle(WorkResult result) async {
    if (!result.success || result.data == null) return;

    final messagesJson = List<Map<String, dynamic>>.from(result.data!['sentMessages'] as List);
    final messages = messagesJson.map((m) => JobChatMessageModel.fromJson(m)).toList();

    await _localDataSource.saveMessages(messages);
    _eventBus.fire(ChatSendCompleteEvent(result.task.id));
  }
}
