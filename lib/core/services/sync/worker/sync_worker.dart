import 'package:flutter/foundation.dart';
import 'package:trackyond/core/services/sync/models/sync_result.dart';
import 'package:trackyond/core/services/sync/models/sync_task.dart';
import 'package:trackyond/core/services/sync/queue/i_sync_queue.dart';
import 'package:trackyond/core/services/sync/sync_service.dart';

class SyncWorker {
  final ISyncQueue _syncQueue;

  SyncWorker(this._syncQueue);

  /// Processes a single task. Returns a [SyncResult] indicating the outcome.
  Future<SyncResult> processTask(SyncTask task) async {
    try {
      final command = SyncService.deserializeCommand(task.enqueueTask.action, task.enqueueTask.data);
      final handler = SyncService.getHandler(command.runtimeType);

      if (handler == null) {
        debugPrint('SyncWorker: No handler registered for command type "${command.runtimeType}". Discarding task.');
        await _syncQueue.deleteTask(task.id);
        return const SyncDiscard('No handler registered');
      }

      final result = await handler.handle(command, task.id);
      
      switch (result) {
        case SyncSuccess():
          debugPrint('SyncWorker: Task ${task.id} (${task.enqueueTask.action}) processed successfully.');
          await _syncQueue.deleteTask(task.id);
          break;
        case SyncRetry(:final reason):
          debugPrint('SyncWorker: Task ${task.id} failed temporarily and will retry. Reason: $reason');
          await _syncQueue.incrementAttempts(task.id);
          break;
        case SyncDiscard(:final reason):
          debugPrint('SyncWorker: Task ${task.id} failed permanently and was discarded. Reason: $reason');
          await _syncQueue.deleteTask(task.id);
          break;
      }
      return result;
    } catch (e) {
      debugPrint('SyncWorker: Exception processing task ${task.id}: $e');
      if (e is ArgumentError) {
        debugPrint('SyncWorker: Task ${task.id} is invalid and cannot be deserialized. Discarding.');
        await _syncQueue.deleteTask(task.id);
        return SyncDiscard('Deserialization failed: $e');
      }
      await _syncQueue.incrementAttempts(task.id);
      return SyncRetry(e.toString());
    }
  }
}
