import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/result_handler/queue_task_result_handler.dart';

class DeleteMessagesResultHandler implements TaskResultHandler {
  @override
  QueueTaskType get type => QueueTaskType.deleteMessages;

  @override
  Future<void> handle(WorkResult result) async {
    // Local DB is already updated beforehand
  }
}
