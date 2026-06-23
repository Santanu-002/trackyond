class JobTable {
  const JobTable._();

  static const String tableName = 'jobs';

  static const columnNames = _JobTableColumns._();

  static String get tableCreate => '''
    CREATE TABLE $tableName (
      ${columnNames.jobId} TEXT PRIMARY KEY,
      ${columnNames.jobTitle} TEXT NOT NULL,
      ${columnNames.customerName} TEXT NOT NULL,
      ${columnNames.customerPhone} TEXT NOT NULL,
      ${columnNames.customerAddress} TEXT,
      ${columnNames.workerProfileUid} TEXT NOT NULL,
      ${columnNames.workerName} TEXT,
      ${columnNames.workerImage} TEXT,
      ${columnNames.createdByProfileUid} TEXT,
      ${columnNames.createdByName} TEXT,
      ${columnNames.jobStatus} TEXT NOT NULL,
      ${columnNames.requirePhotoOnStart} INTEGER NOT NULL,
      ${columnNames.requirePhotoOnComplete} INTEGER NOT NULL,
      ${columnNames.captureLocation} INTEGER NOT NULL,
      ${columnNames.createdAt} TEXT NOT NULL,
      ${columnNames.assignedAt} TEXT,
      ${columnNames.updatedAt} TEXT,
      ${columnNames.completedAt} TEXT,
      ${columnNames.allowedActions} TEXT,
      ${columnNames.lastMessage} TEXT,
      ${columnNames.lastMessageAt} TEXT,
      ${columnNames.lastActivityType} TEXT,
      ${columnNames.lastActivityMessage} TEXT,
      ${columnNames.lastActivityAt} TEXT
    )
  ''';
}

class _JobTableColumns {
  const _JobTableColumns._();

  final String jobId = 'job_id';
  final String jobTitle = 'job_title';
  final String customerName = 'customer_name';
  final String customerPhone = 'customer_phone';
  final String customerAddress = 'customer_address';
  final String workerProfileUid = 'worker_profile_uid';
  final String workerName = 'worker_name';
  final String workerImage = 'worker_image';
  final String createdByProfileUid = 'created_by_profile_uid';
  final String createdByName = 'created_by_name';
  final String jobStatus = 'status';
  final String requirePhotoOnStart = 'require_photo_on_start';
  final String requirePhotoOnComplete = 'require_photo_on_complete';
  final String captureLocation = 'capture_location';
  final String createdAt = 'created_at';
  final String assignedAt = 'assigned_at';
  final String updatedAt = 'updated_at';
  final String completedAt = 'completed_at';
  final String allowedActions = 'allowed_actions';
  final String lastMessage = 'last_message';
  final String lastMessageAt = 'last_message_at';
  final String lastActivityType = 'last_activity_type';
  final String lastActivityMessage = 'last_activity_message';
  final String lastActivityAt = 'last_activity_at';
}
