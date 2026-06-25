import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';
import 'package:trackyond/core/services/queue_service/worker/null_worker.dart';

class QueueWorkerResolver {
  final Map<QueueTaskType, QueueWorker> _workers;

  QueueWorkerResolver(List<QueueWorker> workers)
      : _workers = {for (final w in workers) w.type: w};

  QueueWorker resolve(QueueTaskType type) {
    return _workers[type] ?? NullWorker();
  }
}
