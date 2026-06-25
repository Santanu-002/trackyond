import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/common/enums/queue_priority.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';

part 'queue_task.freezed.dart';
part 'queue_task.g.dart';

class MillisecondsDateTimeConverter implements JsonConverter<DateTime, int> {
  const MillisecondsDateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

class QueuePriorityConverter implements JsonConverter<QueuePriority, int> {
  const QueuePriorityConverter();

  @override
  QueuePriority fromJson(int json) => QueuePriority.values[json];

  @override
  int toJson(QueuePriority object) => object.index;
}

@freezed
sealed class QueueTask with _$QueueTask {
  const factory QueueTask({
    required String id,
    required QueueTaskType type,
    @QueuePriorityConverter() required QueuePriority priority,
    required dynamic payload,
    required QueueTaskStatus status,
    @MillisecondsDateTimeConverter() required DateTime createdAt,
    @MillisecondsDateTimeConverter() required DateTime updatedAt,
  }) = _QueueTask;

  const QueueTask._();

  factory QueueTask.fromJson(Map<String, dynamic> json) => _$QueueTaskFromJson(json);

  Map<String, dynamic> toMap() {
    final json = toJson();
    if (json['payload'] != null) {
      json['payload'] = jsonEncode(json['payload']);
    }
    return json;
  }

  static QueueTask fromMap(Map<String, dynamic> map) {
    final mutableMap = Map<String, dynamic>.from(map);
    if (mutableMap['payload'] is String) {
      mutableMap['payload'] = jsonDecode(mutableMap['payload'] as String);
    }
    return QueueTask.fromJson(mutableMap);
  }
}
