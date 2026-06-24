import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nanoid/nanoid.dart';
import 'package:trackyond/core/services/sync/models/sync_command.dart';

part 'enqueue_task.freezed.dart';
part 'enqueue_task.g.dart';

@freezed
sealed class EnqueueTask with _$EnqueueTask {
  const factory EnqueueTask({
    required String action,
    required Map<String, dynamic> data,
    required String requestId,
  }) = _EnqueueTask;

  const EnqueueTask._();

  factory EnqueueTask.fromCommand(SyncCommand command, {String? requestId}) {
    return EnqueueTask(
      action: command.actionType,
      data: command.toJson(),
      requestId: requestId ?? command.requestId ?? nanoid(12),
    );
  }

  factory EnqueueTask.fromJson(Map<String, dynamic> json) => _$EnqueueTaskFromJson(json);
}
