import 'package:dio/dio.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';

abstract class QueueWorker {
  QueueTaskType get type;
  Future<WorkResult> execute(QueueTask task);
}

class QueueWorkerCancelTracker {
  static final Map<String, CancelToken> _cancelTokens = {};

  static CancelToken getOrCreate(String taskId) {
    return _cancelTokens.putIfAbsent(taskId, () => CancelToken());
  }

  static void cancel(String taskId) {
    final token = _cancelTokens[taskId];
    if (token != null) {
      token.cancel('Upload cancelled by user');
      _cancelTokens.remove(taskId);
    }
  }

  static void remove(String taskId) {
    _cancelTokens.remove(taskId);
  }
}
