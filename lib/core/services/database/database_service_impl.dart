import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/database/tables/job_table.dart';
import 'package:trackyond/core/services/database/tables/chat_message_table.dart';
import 'package:trackyond/core/services/database/tables/member_table.dart';
import 'package:trackyond/core/services/database/tables/sync_queue_table.dart';
import 'package:trackyond/core/services/database/tables/queue_tasks_table.dart';

class DatabaseServiceImpl implements IDatabaseService {
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'trackyond.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute(JobTable.tableCreate);
        await db.execute(ChatMessageTable.tableCreate);
        await db.execute(MemberTable.tableCreate);
        await db.execute(SyncQueueTable.tableCreate);
        await db.execute(QueueTasksTable.tableCreate);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(SyncQueueTable.v1toV2);
        }
        if (oldVersion < 3) {
          // Drop tables to apply new schema and truncate records
          await db.execute('DROP TABLE IF EXISTS ${JobTable.tableName}');
          await db.execute('DROP TABLE IF EXISTS ${ChatMessageTable.tableName}');
          await db.execute('DROP TABLE IF EXISTS ${MemberTable.tableName}');
          await db.execute('DROP TABLE IF EXISTS ${SyncQueueTable.tableName}');
          
          await db.execute(JobTable.tableCreate);
          await db.execute(ChatMessageTable.tableCreate);
          await db.execute(MemberTable.tableCreate);
          await db.execute(SyncQueueTable.tableCreate);
        }
        if (oldVersion < 4) {
          await db.execute(QueueTasksTable.tableCreate);
        }
      },
    );

  }

  @override
  Future<void> insert(
    String table,
    Map<String, dynamic> values, {
    DbConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await _database;
    await db.insert(
      table,
      values,
      conflictAlgorithm: _mapConflictAlgorithm(conflictAlgorithm),
    );
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
  }) async {
    final db = await _database;
    return await db.query(
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
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await _database;
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await _database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    final db = await _database;
    return await db.rawUpdate(sql, arguments);
  }

  @override
  Future<void> transaction(Future<void> Function(IDatabaseTransaction txn) action) async {
    final db = await _database;
    await db.transaction((sqfliteTxn) async {
      final wrappedTxn = _DatabaseTransactionImpl(sqfliteTxn);
      await action(wrappedTxn);
    });
  }

  @override
  Future<void> clearAllTables() async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.delete(JobTable.tableName);
      await txn.delete(ChatMessageTable.tableName);
      await txn.delete(MemberTable.tableName);
      await txn.delete(SyncQueueTable.tableName);
      await txn.delete(QueueTasksTable.tableName);
    });
  }

  static ConflictAlgorithm? _mapConflictAlgorithm(DbConflictAlgorithm? alg) {
    if (alg == null) return null;
    switch (alg) {
      case DbConflictAlgorithm.replace:
        return ConflictAlgorithm.replace;
      case DbConflictAlgorithm.ignore:
        return ConflictAlgorithm.ignore;
      case DbConflictAlgorithm.abort:
        return ConflictAlgorithm.abort;
    }
  }
}

class _DatabaseTransactionImpl implements IDatabaseTransaction {
  final Transaction _txn;

  _DatabaseTransactionImpl(this._txn);

  @override
  Future<void> insert(
    String table,
    Map<String, dynamic> values, {
    DbConflictAlgorithm? conflictAlgorithm,
  }) async {
    await _txn.insert(
      table,
      values,
      conflictAlgorithm: DatabaseServiceImpl._mapConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await _txn.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await _txn.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
}
