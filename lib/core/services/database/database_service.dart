enum DbConflictAlgorithm { replace, ignore, abort }

abstract class IDatabaseService {
  Future<void> insert(
    String table,
    Map<String, dynamic> values, {
    DbConflictAlgorithm? conflictAlgorithm,
  });

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String>? columns,
  });

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> rawUpdate(String sql, [List<Object?>? arguments]);

  Future<void> transaction(Future<void> Function(IDatabaseTransaction txn) action);

  Future<void> clearAllTables();
}

abstract class IDatabaseTransaction {
  Future<void> insert(
    String table,
    Map<String, dynamic> values, {
    DbConflictAlgorithm? conflictAlgorithm,
  });

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
}
