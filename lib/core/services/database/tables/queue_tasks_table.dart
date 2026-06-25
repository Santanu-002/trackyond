class QueueTasksTable {
  const QueueTasksTable._();

  static const String tableName = 'queue_tasks';

  static const columnNames = _QueueTasksTableColumns._();

  static String get tableCreate => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      ${columnNames.id} TEXT PRIMARY KEY,
      ${columnNames.type} TEXT NOT NULL,
      ${columnNames.priority} INTEGER NOT NULL,
      ${columnNames.payload} TEXT NOT NULL,
      ${columnNames.status} TEXT NOT NULL,
      ${columnNames.createdAt} INTEGER NOT NULL,
      ${columnNames.updatedAt} INTEGER NOT NULL
    );
  ''';
}

class _QueueTasksTableColumns {
  const _QueueTasksTableColumns._();

  final String id = 'id';
  final String type = 'type';
  final String priority = 'priority';
  final String payload = 'payload';
  final String status = 'status';
  final String createdAt = 'createdAt';
  final String updatedAt = 'updatedAt';
}
