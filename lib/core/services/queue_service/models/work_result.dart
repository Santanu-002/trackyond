import 'package:trackyond/core/common/models/queue/queue_task.dart';

class WorkResult {
  final QueueTask task;
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  WorkResult.success({
    required this.task,
    required this.message,
    this.data,
  }) : success = true;

  WorkResult.failure({
    required this.task,
    required this.message,
    this.data,
  }) : success = false;
}
