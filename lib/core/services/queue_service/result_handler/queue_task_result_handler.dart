import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';

abstract class TaskResultHandler {
  QueueTaskType get type;
  Future<void> handle(WorkResult result);
}
