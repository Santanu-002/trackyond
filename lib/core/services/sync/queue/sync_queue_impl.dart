import 'dart:convert';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/database/tables/sync_queue_table.dart';
import 'package:trackyond/core/services/sync/models/sync_task.dart';
import 'package:trackyond/core/services/sync/queue/i_sync_queue.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/sync_priority.dart';

class SyncQueueImpl implements ISyncQueue {
  final IDatabaseService _databaseService;

  SyncQueueImpl(this._databaseService);

  @override
  Future<void> enqueue(EnqueueTask task, {SyncPriority priority = SyncPriority.normal}) async {
    await _databaseService.insert(
      SyncQueueTable.tableName,
      {
        SyncQueueTable.columnNames.actionType: task.action,
        SyncQueueTable.columnNames.payload: jsonEncode(task.toJson()),
        SyncQueueTable.columnNames.createdAt: DateTime.now().millisecondsSinceEpoch,
        SyncQueueTable.columnNames.attempts: 0,
        SyncQueueTable.columnNames.priority: priority.value,
      },
    );
  }

  @override
  Future<List<SyncTask>> getPendingTasks() async {
    final List<Map<String, dynamic>> maps = await _databaseService.query(
      SyncQueueTable.tableName,
      orderBy: '${SyncQueueTable.columnNames.priority} DESC, ${SyncQueueTable.columnNames.createdAt} ASC',
    );
    return maps.map((map) => SyncTask.fromDbMap(map)).toList();
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await _databaseService.delete(
      SyncQueueTable.tableName,
      where: '${SyncQueueTable.columnNames.id} = ?',
      whereArgs: [taskId],
    );
  }

  @override
  Future<void> incrementAttempts(int taskId) async {
    await _databaseService.rawUpdate(
      '''
      UPDATE ${SyncQueueTable.tableName}
      SET ${SyncQueueTable.columnNames.attempts} = ${SyncQueueTable.columnNames.attempts} + 1
      WHERE ${SyncQueueTable.columnNames.id} = ?
      ''',
      [taskId],
    );
  }

  @override
  Future<void> updatePayload(int taskId, EnqueueTask task) async {
    await _databaseService.update(
      SyncQueueTable.tableName,
      {SyncQueueTable.columnNames.payload: jsonEncode(task.toJson())},
      where: '${SyncQueueTable.columnNames.id} = ?',
      whereArgs: [taskId],
    );
  }
}

