class ChatMessageTable {
  const ChatMessageTable._();

  static const String tableName = 'chat_messages';

  static const columnNames = _ChatMessageTableColumns._();

  static String get tableCreate => '''
    CREATE TABLE $tableName (
      ${columnNames.uid} TEXT PRIMARY KEY,
      ${columnNames.serverUid} TEXT,
      ${columnNames.jobId} TEXT NOT NULL,
      ${columnNames.senderUid} TEXT,
      ${columnNames.type} TEXT NOT NULL,
      ${columnNames.actionPerformed} TEXT,
      ${columnNames.createdByAuthorAt} TEXT NOT NULL,
      ${columnNames.createdAt} TEXT,
      ${columnNames.updatedAt} TEXT,
      ${columnNames.seenAt} TEXT,
      ${columnNames.deliveredAt} TEXT,
      ${columnNames.active} INTEGER NOT NULL,
      ${columnNames.deleted} INTEGER NOT NULL,
      ${columnNames.deletedByUid} TEXT,
      ${columnNames.deletedByUserType} TEXT,
      ${columnNames.deletedFor} TEXT,
      ${columnNames.deletedAt} TEXT,
      ${columnNames.deletedByUserAt} TEXT,
      ${columnNames.content} TEXT NOT NULL,
      ${columnNames.metadata} TEXT
    )
  ''';
}

class _ChatMessageTableColumns {
  const _ChatMessageTableColumns._();

  final String uid = 'uid';
  final String serverUid = 'server_uid';
  final String jobId = 'job_id';
  final String senderUid = 'sender_uid';
  final String type = 'type';
  final String actionPerformed = 'action_performed';
  final String createdByAuthorAt = 'created_by_author_at';
  final String createdAt = 'created_at';
  final String updatedAt = 'updated_at';
  final String seenAt = 'seen_at';
  final String deliveredAt = 'delivered_at';
  final String active = 'active';
  final String deleted = 'deleted';
  final String deletedByUid = 'deleted_by_uid';
  final String deletedByUserType = 'deleted_by_user_type';
  final String deletedFor = 'deleted_for';
  final String deletedAt = 'deleted_at';
  final String deletedByUserAt = 'deleted_by_user_at';
  final String content = 'content';
  final String metadata = 'metadata';
}
