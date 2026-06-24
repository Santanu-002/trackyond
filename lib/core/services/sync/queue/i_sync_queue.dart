import 'package:trackyond/core/services/sync/models/sync_task.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/sync_priority.dart';

abstract interface class ISyncQueue {
  Future<void> enqueue(EnqueueTask task, {SyncPriority priority = SyncPriority.normal});
  Future<List<SyncTask>> getPendingTasks();
  Future<void> deleteTask(int taskId);
  Future<void> incrementAttempts(int taskId);
  Future<void> updatePayload(int taskId, EnqueueTask task);
}

