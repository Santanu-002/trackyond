class NotificationConstants {
  const NotificationConstants._();

  static const dataKeys = NotificationDataKeys();
  static const statuses = NotificationStatuses();
  static const types = NotificationTypes();
  static const storageKeys = NotificationStorageKeys();
  static const localChannel = LocalNotificationChannelConstants();
}

class NotificationDataKeys {
  const NotificationDataKeys();

  String get job => 'job';
  String get id => 'id';
  String get notificationId => 'notificationId';
  String get notificationIds => 'notificationIds';
  String get status => 'status';
  String get type => 'type';
}

class NotificationStatuses {
  const NotificationStatuses();

  String get delivered => 'delivered';
  String get read => 'read';
  String get seen => 'seen';
}

class NotificationTypes {
  const NotificationTypes();

  String get jobAssigned => 'jobAssigned';
  String get jobChatMessage => 'jobChatMessage';
}

class NotificationStorageKeys {
  const NotificationStorageKeys();

  String get failedAcks => 'failed_acks';
}

class LocalNotificationChannelConstants {
  const LocalNotificationChannelConstants();

  String get jobChannelId => 'trackyond_job_channel';
  String get jobChannelName => 'Job Notifications';
  String get jobChannelDescription =>
      'Notifications for job assignments and updates';
  String get launcherIcon => '@mipmap/ic_launcher';
}
