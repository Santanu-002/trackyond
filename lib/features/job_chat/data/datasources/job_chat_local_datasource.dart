import 'dart:convert';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/services/database/tables/job_table.dart';
import 'package:trackyond/core/services/database/tables/chat_message_table.dart';
import 'package:trackyond/core/services/database/tables/member_table.dart';
import 'package:trackyond/core/services/database/tables/sync_queue_table.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';

abstract interface class IJobChatLocalDataSource {
  // Messages
  Future<void> saveMessages(List<JobChatMessageModel> messages);
  Future<List<JobChatMessageModel>> getCachedMessages(
    String jobId, {
    int? limit,
    int? offset,
  });
  Future<void> deleteCachedMessages(List<String> messageUids);
  Future<void> markMessagesAsSeen(
    String jobId,
    List<String> messageUids,
    DateTime seenAt,
  );
  Future<void> markMessagesAsDelivered(
    String jobId,
    List<String> messageUids,
    DateTime deliveredAt,
  );

  // Members
  Future<void> saveChatMembers(List<MemberProfileModel> members);
  Future<List<MemberProfileModel>> getCachedChatMembers(String jobId);

  // Outbox / Sync Queue
  Future<void> enqueueSyncTask(String actionType, Map<String, dynamic> payload);
  Future<List<Map<String, dynamic>>> getPendingSyncTasks();
  Future<void> deleteSyncTask(int id);
  Future<void> incrementSyncTaskAttempts(int id);
}

class JobChatLocalDataSourceImpl implements IJobChatLocalDataSource {
  final IDatabaseService _databaseService;

  JobChatLocalDataSourceImpl(this._databaseService);

  @override
  Future<void> saveMessages(List<JobChatMessageModel> messages) async {
    await _databaseService.transaction((txn) async {
      for (final msg in messages) {
        if (msg.localId != null) {
          await txn.delete(
            ChatMessageTable.tableName,
            where: '${ChatMessageTable.columnNames.localId} = ? AND ${ChatMessageTable.columnNames.uid} != ?',
            whereArgs: [msg.localId, msg.uid],
          );
        }
        await txn.insert(
          ChatMessageTable.tableName,
          msg.toDbMap(),
          conflictAlgorithm: DbConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<List<JobChatMessageModel>> getCachedMessages(
    String jobId, {
    int? limit,
    int? offset,
  }) async {
    final List<Map<String, dynamic>> maps = await _databaseService.query(
      ChatMessageTable.tableName,
      where: '${ChatMessageTable.columnNames.jobId} = ?',
      whereArgs: [jobId],
      orderBy: '${ChatMessageTable.columnNames.createdByAuthorAt} ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => JobChatMessageModel.fromDbMap(map)).toList();
  }

  @override
  Future<void> deleteCachedMessages(List<String> messageUids) async {
    if (messageUids.isEmpty) return;
    await _databaseService.transaction((txn) async {
      for (final uid in messageUids) {
        await txn.update(
          ChatMessageTable.tableName,
          {
            ChatMessageTable.columnNames.active: 0,
            ChatMessageTable.columnNames.deleted: 1,
            ChatMessageTable.columnNames.deletedAt: DateTime.now().toUtc().toIso8601String(),
          },
          where: '${ChatMessageTable.columnNames.uid} = ?',
          whereArgs: [uid],
        );
      }
    });
  }

  @override
  Future<void> markMessagesAsSeen(
    String jobId,
    List<String> messageUids,
    DateTime seenAt,
  ) async {
    final seenAtStr = seenAt.toUtc().toIso8601String();
    
    if (messageUids.isEmpty) {
      await _databaseService.update(
        ChatMessageTable.tableName,
        {ChatMessageTable.columnNames.seenAt: seenAtStr},
        where: '${ChatMessageTable.columnNames.jobId} = ? AND ${ChatMessageTable.columnNames.seenAt} IS NULL',
        whereArgs: [jobId],
      );
    } else {
      await _databaseService.transaction((txn) async {
        for (final uid in messageUids) {
          await txn.update(
            ChatMessageTable.tableName,
            {ChatMessageTable.columnNames.seenAt: seenAtStr},
            where: '${ChatMessageTable.columnNames.uid} = ?',
            whereArgs: [uid],
          );
        }
      });
    }
  }

  @override
  Future<void> markMessagesAsDelivered(
    String jobId,
    List<String> messageUids,
    DateTime deliveredAt,
  ) async {
    if (messageUids.isEmpty) return;
    final deliveredAtStr = deliveredAt.toUtc().toIso8601String();

    await _databaseService.transaction((txn) async {
      for (final uid in messageUids) {
        await txn.update(
          ChatMessageTable.tableName,
          {ChatMessageTable.columnNames.deliveredAt: deliveredAtStr},
          where: '${ChatMessageTable.columnNames.uid} = ?',
          whereArgs: [uid],
        );
      }
    });
  }

  @override
  Future<void> saveChatMembers(List<MemberProfileModel> members) async {
    await _databaseService.transaction((txn) async {
      for (final member in members) {
        await txn.insert(
          MemberTable.tableName,
          member.toDbMap(),
          conflictAlgorithm: DbConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<List<MemberProfileModel>> getCachedChatMembers(String jobId) async {
    final jobMaps = await _databaseService.query(
      JobTable.tableName,
      columns: [
        JobTable.columnNames.workerProfileUid,
        JobTable.columnNames.createdByProfileUid
      ],
      where: '${JobTable.columnNames.jobId} = ?',
      whereArgs: [jobId],
    );

    if (jobMaps.isEmpty) return [];

    final jobMap = jobMaps.first;
    final workerUid = jobMap[JobTable.columnNames.workerProfileUid] as String?;
    final creatorUid = jobMap[JobTable.columnNames.createdByProfileUid] as String?;

    final uids = <String>[];
    if (workerUid != null) uids.add(workerUid);
    if (creatorUid != null) uids.add(creatorUid);

    if (uids.isEmpty) return [];

    final placeholders = List.filled(uids.length, '?').join(', ');
    final memberMaps = await _databaseService.query(
      MemberTable.tableName,
      where: '${MemberTable.columnNames.uid} IN ($placeholders)',
      whereArgs: uids,
    );

    return memberMaps.map((map) => MemberProfileModel.fromDbMap(map)).toList();
  }

  @override
  Future<void> enqueueSyncTask(
    String actionType,
    Map<String, dynamic> payload,
  ) async {
    await _databaseService.insert(
      SyncQueueTable.tableName,
      {
        SyncQueueTable.columnNames.actionType: actionType,
        SyncQueueTable.columnNames.payload: jsonEncode(payload),
        SyncQueueTable.columnNames.createdAt: DateTime.now().millisecondsSinceEpoch,
        SyncQueueTable.columnNames.attempts: 0,
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingSyncTasks() async {
    return await _databaseService.query(
      SyncQueueTable.tableName,
      orderBy: '${SyncQueueTable.columnNames.createdAt} ASC',
    );
  }

  @override
  Future<void> deleteSyncTask(int id) async {
    await _databaseService.delete(
      SyncQueueTable.tableName,
      where: '${SyncQueueTable.columnNames.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> incrementSyncTaskAttempts(int id) async {
    await _databaseService.rawUpdate('''
      UPDATE ${SyncQueueTable.tableName}
      SET ${SyncQueueTable.columnNames.attempts} = ${SyncQueueTable.columnNames.attempts} + 1
      WHERE ${SyncQueueTable.columnNames.id} = ?
    ''', [id]);
  }
}
