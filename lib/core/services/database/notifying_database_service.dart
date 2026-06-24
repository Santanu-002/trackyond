import 'package:flutter/foundation.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/events/job_event.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/database/tables/chat_message_table.dart';
import 'package:trackyond/core/services/database/tables/job_table.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/core/common/enums/job_chat_message_status.dart';

enum DbOperation {
  insert,
  update,
  delete,
}

class NotifyingDatabaseService implements IDatabaseService {
  final IDatabaseService _db;
  final IEventBusRepository _eventBus;

  NotifyingDatabaseService(this._db, this._eventBus);

  String? _getIdKey(String table) {
    if (table == JobTable.tableName) return 'job_id';
    if (table == ChatMessageTable.tableName) return 'uid';
    return null;
  }

  Future<void> _notifyChange(
    String table,
    DbOperation operation, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    if (operation == DbOperation.delete) {
      if (table == JobTable.tableName && whereArgs != null && whereArgs.isNotEmpty) {
        _eventBus.fire(JobDeletedEvent(whereArgs.first.toString()));
      }
      return;
    }


    try {
      // Query the database to get the updated row(s)
      final List<Map<String, dynamic>> rows = await _db.query(
        table,
        where: where,
        whereArgs: whereArgs,
      );

      for (final row in rows) {
        if (table == JobTable.tableName) {
          final model = JobModel.fromDbMap(row);
          if (operation == DbOperation.insert) {
            _eventBus.fire(JobInsertedEvent([model.toEntity()]));
          } else {
            _eventBus.fire(JobUpdatedEvent(model.toEntity()));
          }
        } else if (table == ChatMessageTable.tableName) {
          final model = JobChatMessageModel.fromDbMap(row);
          if (operation == DbOperation.insert) {
            // Also fetch the JobEntity from the DB to populate the ChatMessageReceivedEvent
            JobEntity? jobEntity;
            try {
              final jobRows = await _db.query(
                JobTable.tableName,
                where: 'job_id = ?',
                whereArgs: [model.jobId],
              );
              if (jobRows.isNotEmpty) {
                jobEntity = JobModel.fromDbMap(jobRows.first).toEntity();
              }
            } catch (e) {
              debugPrint('NotifyingDatabaseService: Error querying job relation: $e');
            }
            _eventBus.fire(ChatMessageReceivedEvent(model, job: jobEntity));
          } else {
            final status = model.status;
            if (status == JobChatMessageStatus.seen) {
              _eventBus.fire(ChatMessageReadEvent(
                jobId: model.jobId,
                messageUids: [model.uid],
                seenAt: model.seenAt ?? DateTime.now(),
              ));
            } else if (status == JobChatMessageStatus.delivered) {
              _eventBus.fire(ChatMessageDeliveredEvent(
                jobId: model.jobId,
                messageUids: [model.uid],
                deliveredAt: model.deliveredAt ?? DateTime.now(),
              ));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('NotifyingDatabaseService: Error notifying change for table $table: $e');
    }
  }

  @override
  Future<void> insert(
    String table,
    Map<String, dynamic> values, {
    DbConflictAlgorithm? conflictAlgorithm,
  }) async {
    await _db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
    final idKey = _getIdKey(table);
    if (idKey != null && values[idKey] != null) {
      await _notifyChange(table, DbOperation.insert, where: '$idKey = ?', whereArgs: [values[idKey]]);
    }
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rowsAffected = await _db.update(table, values, where: where, whereArgs: whereArgs);
    if (rowsAffected > 0) {
      await _notifyChange(table, DbOperation.update, where: where, whereArgs: whereArgs);
    }
    return rowsAffected;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rowsAffected = await _db.delete(table, where: where, whereArgs: whereArgs);
    if (rowsAffected > 0) {
      await _notifyChange(table, DbOperation.delete, where: where, whereArgs: whereArgs);
    }
    return rowsAffected;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String>? columns,
  }) {
    return _db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      columns: columns,
    );
  }

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) {
    return _db.rawUpdate(sql, arguments);
  }

  @override
  Future<void> transaction(Future<void> Function(IDatabaseTransaction txn) action) async {
    final pendingNotifications = <Future<void> Function()>[];

    final txnWrapper = _NotifyingDatabaseTransaction(
      (table, op, {where, whereArgs}) {
        pendingNotifications.add(() => _notifyChange(table, op, where: where, whereArgs: whereArgs));
      },
      _getIdKey,
    );

    await _db.transaction((innerTxn) async {
      txnWrapper.setInnerTxn(innerTxn);
      await action(txnWrapper);
    });

    for (final notify in pendingNotifications) {
      await notify();
    }
  }

  @override
  Future<void> clearAllTables() {
    return _db.clearAllTables();
  }
}

class _NotifyingDatabaseTransaction implements IDatabaseTransaction {
  final void Function(String table, DbOperation op, {String? where, List<Object?>? whereArgs}) _onAction;
  final String? Function(String table) _getIdKey;
  late IDatabaseTransaction _innerTxn;

  _NotifyingDatabaseTransaction(this._onAction, this._getIdKey);

  void setInnerTxn(IDatabaseTransaction innerTxn) {
    _innerTxn = innerTxn;
  }

  @override
  Future<void> insert(
    String table,
    Map<String, dynamic> values, {
    DbConflictAlgorithm? conflictAlgorithm,
  }) async {
    await _innerTxn.insert(table, values, conflictAlgorithm: conflictAlgorithm);
    final idKey = _getIdKey(table);
    if (idKey != null && values[idKey] != null) {
      _onAction(table, DbOperation.insert, where: '$idKey = ?', whereArgs: [values[idKey]]);
    }
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rows = await _innerTxn.update(table, values, where: where, whereArgs: whereArgs);
    if (rows > 0) {
      _onAction(table, DbOperation.update, where: where, whereArgs: whereArgs);
    }
    return rows;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rows = await _innerTxn.delete(table, where: where, whereArgs: whereArgs);
    if (rows > 0) {
      _onAction(table, DbOperation.delete, where: where, whereArgs: whereArgs);
    }
    return rows;
  }
}
