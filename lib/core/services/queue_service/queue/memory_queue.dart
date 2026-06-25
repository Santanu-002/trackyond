import 'package:collection/collection.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';

class MemoryQueue {
  final PriorityQueue<QueueTask> _queue = PriorityQueue<QueueTask>(_compare);

  static int _compare(QueueTask a, QueueTask b) {
    final priorityCompare = a.priority.index.compareTo(b.priority.index);
    if (priorityCompare != 0) return priorityCompare;
    return a.createdAt.compareTo(b.createdAt);
  }

  void add(QueueTask task) => _queue.add(task);

  QueueTask? take() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
  int get length => _queue.length;
  void clear() => _queue.clear();
}
