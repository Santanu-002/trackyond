import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/services/database/tables/job_table.dart';
import 'package:trackyond/core/services/database/tables/chat_message_table.dart';
import 'package:trackyond/core/services/database/tables/member_table.dart';
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
  Future<void> deleteCachedMessages(
    List<String> messageUids, {
    required String deleteType,
    String? deletedByUid,
    String? deletedByUserType,
    DateTime? deletedByUserAt,
  });
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
  Future<JobChatMessageModel?> getMessageByUid(String uid);

  // Members
  Future<void> saveChatMembers(List<MemberProfileModel> members);
  Future<List<MemberProfileModel>> getCachedChatMembers(String jobId);
}

class JobChatLocalDataSourceImpl implements IJobChatLocalDataSource {
  final IDatabaseService _databaseService;

  JobChatLocalDataSourceImpl(this._databaseService);

  @override
  Future<JobChatMessageModel?> getMessageByUid(String uid) async {
    final List<Map<String, dynamic>> maps = await _databaseService.query(
      ChatMessageTable.tableName,
      where: '${ChatMessageTable.columnNames.uid} = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return JobChatMessageModel.fromDbMap(maps.first);
  }

  @override
  Future<void> saveMessages(List<JobChatMessageModel> messages) async {
    await _databaseService.transaction((txn) async {
      for (final msg in messages) {
        if (msg.serverUid != null) {
          await txn.delete(
            ChatMessageTable.tableName,
            where: '${ChatMessageTable.columnNames.serverUid} = ? AND ${ChatMessageTable.columnNames.uid} != ?',
            whereArgs: [msg.serverUid, msg.uid],
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
      // DESC so that with LIMIT+OFFSET we get the most-recent window of messages.
      // Callers reverse the result to restore chronological (ASC) order.
      orderBy: '${ChatMessageTable.columnNames.createdByAuthorAt} DESC',
      limit: limit,
      offset: offset,
    );

    // Reverse DESC → ASC so the list is always chronologically sorted (oldest first).
    return maps.reversed.map((map) => JobChatMessageModel.fromDbMap(map)).toList();
  }

  @override
  Future<void> deleteCachedMessages(
    List<String> messageUids, {
    required String deleteType,
    String? deletedByUid,
    String? deletedByUserType,
    DateTime? deletedByUserAt,
  }) async {
    if (messageUids.isEmpty) return;
    await _databaseService.transaction((txn) async {
      for (final uid in messageUids) {
        if (deleteType == 'forMe') {
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
        } else {
          // forEveryone
          await txn.update(
            ChatMessageTable.tableName,
            {
              ChatMessageTable.columnNames.active: 1, // Keep it active so the placeholder renders
              ChatMessageTable.columnNames.deleted: 1,
              ChatMessageTable.columnNames.deletedByUid: deletedByUid,
              ChatMessageTable.columnNames.deletedByUserType: deletedByUserType,
              ChatMessageTable.columnNames.deletedAt: DateTime.now().toUtc().toIso8601String(),
              ChatMessageTable.columnNames.deletedByUserAt: (deletedByUserAt ?? DateTime.now()).toUtc().toIso8601String(),
              ChatMessageTable.columnNames.content: '[]', // Clear content
            },
            where: '${ChatMessageTable.columnNames.uid} = ?',
            whereArgs: [uid],
          );
        }
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
}
