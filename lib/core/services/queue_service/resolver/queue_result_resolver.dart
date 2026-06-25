import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/result_handler/queue_task_result_handler.dart';
import 'package:trackyond/core/services/queue_service/result_handler/null_result_handler.dart';

class QueueResultResolver {
  final Map<QueueTaskType, TaskResultHandler> _handlers;

  QueueResultResolver(List<TaskResultHandler> handlers)
      : _handlers = {for (final h in handlers) h.type: h};

  TaskResultHandler resolve(QueueTaskType type) {
    return _handlers[type] ?? NullResultHandler();
  }
}
