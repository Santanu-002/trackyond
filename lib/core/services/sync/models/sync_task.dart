import 'dart:convert';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/sync_priority.dart';

class SyncTask {
  final int id;
  final EnqueueTask enqueueTask;
  final int createdAt;
  final int attempts;
  final SyncPriority priority;

  const SyncTask({
    required this.id,
    required this.enqueueTask,
    required this.createdAt,
    required this.attempts,
    required this.priority,
  });

  factory SyncTask.fromDbMap(Map<String, dynamic> map) {
    final payloadMap = jsonDecode(map['payload'] as String) as Map<String, dynamic>;
    if (!payloadMap.containsKey('requestId')) {
      payloadMap['requestId'] = 'legacy_${map['id']}';
    }
    return SyncTask(
      id: map['id'] as int,
      enqueueTask: EnqueueTask.fromJson(payloadMap),
      createdAt: map['created_at'] as int,
      attempts: map['attempts'] as int? ?? 0,
      priority: SyncPriority.fromInt(map['priority'] as int? ?? 1),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'action_type': enqueueTask.action,
      'payload': jsonEncode(enqueueTask.toJson()),
      'created_at': createdAt,
      'attempts': attempts,
      'priority': priority.value,
    };
  }
}

