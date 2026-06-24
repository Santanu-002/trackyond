class SyncQueueTable {
  const SyncQueueTable._();

  static const String tableName = 'sync_queue';

  static const columnNames = _SyncQueueTableColumns._();

  static String get tableCreate => '''
    CREATE TABLE $tableName (
      ${columnNames.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${columnNames.actionType} TEXT NOT NULL,
      ${columnNames.payload} TEXT NOT NULL,
      ${columnNames.createdAt} INTEGER NOT NULL,
      ${columnNames.attempts} INTEGER NOT NULL DEFAULT 0,
      ${columnNames.priority} INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static String get v1toV2 => 'ALTER TABLE $tableName ADD COLUMN ${columnNames.priority} INTEGER NOT NULL DEFAULT 1';
}

class _SyncQueueTableColumns {
  const _SyncQueueTableColumns._();

  final String id = 'id';
  final String actionType = 'action_type';
  final String payload = 'payload';
  final String createdAt = 'created_at';
  final String attempts = 'attempts';
  final String priority = 'priority';
}

