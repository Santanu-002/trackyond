import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/database/tables/queue_tasks_table.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';
import 'package:trackyond/core/services/queue_service/queue/memory_queue.dart';
import 'package:trackyond/core/services/queue_service/resolver/queue_worker_resolver.dart';
import 'package:trackyond/core/services/queue_service/resolver/queue_result_resolver.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';

class QueueService extends GetxService {
  final IDatabaseService _databaseService;
  final QueueWorkerResolver _workerResolver;
  final QueueResultResolver _resultResolver;
  final MemoryQueue _memoryQueue = MemoryQueue();

  bool _running = false;
  QueueTask? _currentTask;

  QueueService({
    required IDatabaseService databaseService,
    required QueueWorkerResolver workerResolver,
    required QueueResultResolver resultResolver,
  })  : _databaseService = databaseService,
        _workerResolver = workerResolver,
        _resultResolver = resultResolver;

  static QueueService get find => Get.find<QueueService>();

  @override
  void onInit() {
    super.onInit();
    _loadPendingTasks();
  }

  Future<void> _loadPendingTasks() async {
    try {
      // Reset any stale processing tasks from previous sessions to failed
      await _databaseService.update(
        QueueTasksTable.tableName,
        {'status': QueueTaskStatus.failed.name},
        where: 'status = ?',
        whereArgs: [QueueTaskStatus.processing.name],
      );

      final rows = await _databaseService.query(
        QueueTasksTable.tableName,
        where: 'status = ?',
        whereArgs: [QueueTaskStatus.pending.name],
        orderBy: 'priority ASC, createdAt ASC',
      );
      for (final row in rows) {
        _memoryQueue.add(QueueTask.fromMap(row));
      }
      run();
    } catch (e) {
      debugPrint('QueueService: Error loading pending tasks: $e');
    }
  }

  Future<void> enqueue(QueueTask task) async {
    try {
      await _databaseService.insert(
        QueueTasksTable.tableName,
        task.toMap(),
      );
      _memoryQueue.add(task);
      run();
    } catch (e) {
      debugPrint('QueueService: Error enqueuing task: $e');
    }
  }

  Future<void> cancel(String taskId) async {
    if (_currentTask != null && _currentTask!.id == taskId) {
      QueueWorkerCancelTracker.cancel(taskId);
    }

    await _databaseService.delete(
      QueueTasksTable.tableName,
      where: 'id = ?',
      whereArgs: [taskId],
    );

    // Rebuild memory queue without the cancelled task
    final tempQueue = MemoryQueue();
    while (_memoryQueue.isNotEmpty) {
      final t = _memoryQueue.take();
      if (t != null && t.id != taskId) {
        tempQueue.add(t);
      }
    }
    _memoryQueue.clear();
    while (tempQueue.isNotEmpty) {
      final t = tempQueue.take();
      if (t != null) _memoryQueue.add(t);
    }
  }

  Future<void> retry(String taskId) async {
    debugPrint('QueueService: Attempting to retry task: $taskId');
    final rows = await _databaseService.query(
      QueueTasksTable.tableName,
      where: 'id = ?',
      whereArgs: [taskId],
      limit: 1,
    );

    if (rows.isEmpty) {
      debugPrint('QueueService: Task not found in DB for retry: $taskId');
      return;
    }

    final existingTask = QueueTask.fromMap(rows.first);
    final resetTask = QueueTask(
      id: existingTask.id,
      type: existingTask.type,
      priority: existingTask.priority,
      payload: existingTask.payload,
      status: QueueTaskStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _databaseService.update(
      QueueTasksTable.tableName,
      resetTask.toMap(),
      where: 'id = ?',
      whereArgs: [taskId],
    );

    _memoryQueue.add(resetTask);
    run();
  }

  Future<void> run() async {
    if (_running) return;
    _running = true;

    try {
      while (_memoryQueue.isNotEmpty) {
        final task = _memoryQueue.take();
        if (task == null) break;

        _currentTask = task;

        await _databaseService.update(
          QueueTasksTable.tableName,
          {
            'status': QueueTaskStatus.processing.name,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          },
          where: 'id = ?',
          whereArgs: [task.id],
        );

        final worker = _workerResolver.resolve(task.type);
        final result = await worker.execute(task);

        if (result.success) {
          await _databaseService.delete(
            QueueTasksTable.tableName,
            where: 'id = ?',
            whereArgs: [task.id],
          );
        } else {
          await _databaseService.update(
            QueueTasksTable.tableName,
            {
              'status': QueueTaskStatus.failed.name,
              'updatedAt': DateTime.now().millisecondsSinceEpoch,
            },
            where: 'id = ?',
            whereArgs: [task.id],
          );
        }

        final handler = _resultResolver.resolve(task.type);
        await handler.handle(result);
      }
    } finally {
      _currentTask = null;
      _running = false;
    }
  }
}
