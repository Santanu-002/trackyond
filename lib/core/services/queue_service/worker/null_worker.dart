import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';

class NullWorker implements QueueWorker {
  @override
  QueueTaskType get type => QueueTaskType.none;

  @override
  Future<WorkResult> execute(QueueTask task) async {
    return WorkResult.success(task: task, message: 'No action performed');
  }
}
