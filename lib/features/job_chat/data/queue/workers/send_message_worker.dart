import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/request/send_message_model.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/events/chat_event.dart';

class SendMessageWorker implements QueueWorker {
  final IJobChatRemoteDataSource _remoteDataSource;
  final IEventBusRepository _eventBus;

  SendMessageWorker({
    required IJobChatRemoteDataSource remoteDataSource,
    required IEventBusRepository eventBus,
  })  : _remoteDataSource = remoteDataSource,
        _eventBus = eventBus;

  @override
  QueueTaskType get type => QueueTaskType.sendMessage;

  @override
  Future<WorkResult> execute(QueueTask task) async {
    final payload = task.payload as Map<String, dynamic>;
    final messagesJson = List<Map<String, dynamic>>.from(payload['messages'] as List);

    final sendModels = messagesJson
        .map((m) => SendMessageModel.fromJson(m))
        .toList();

    try {
      final remoteResult = await _remoteDataSource.sendMessage(
        messages: sendModels,
      );

      return remoteResult.fold(
        (failure) {
          _eventBus.fire(ChatUploadErrorEvent(task.id, failure.message));
          return WorkResult.failure(task: task, message: failure.message);
        },
        (responseModel) {
          if (responseModel == null) {
            _eventBus.fire(ChatUploadErrorEvent(task.id, 'Empty response'));
            return WorkResult.failure(task: task, message: 'Empty response');
          }
          return WorkResult.success(
            task: task,
            message: 'Message sent successfully',
            data: {
              'sentMessages': responseModel.messages.map((m) {
                final map = m.toJson();
                map['localUid'] = m.uid;
                map['uid'] = m.serverUid;
                return map;
              }).toList(),
            },
          );
        },
      );
    } catch (e) {
      _eventBus.fire(ChatUploadErrorEvent(task.id, e.toString()));
      return WorkResult.failure(task: task, message: e.toString());
    }
  }
}
