import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/common/enums/queue_priority.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/services/queue_service/queue/memory_queue.dart';
import 'package:trackyond/core/services/queue_service/resolver/queue_worker_resolver.dart';
import 'package:trackyond/core/services/queue_service/resolver/queue_result_resolver.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';
import 'package:trackyond/core/services/queue_service/worker/null_worker.dart';
import 'package:trackyond/core/services/queue_service/result_handler/queue_task_result_handler.dart';
import 'package:trackyond/core/services/queue_service/result_handler/null_result_handler.dart';

class MockQueueWorker extends Mock implements QueueWorker {}
class MockTaskResultHandler extends Mock implements TaskResultHandler {}

void main() {
  group('MemoryQueue tests', () {
    test('tasks are prioritized correctly', () {
      final queue = MemoryQueue();

      final t1 = QueueTask(
        id: '1',
        type: QueueTaskType.sendMessage,
        priority: QueuePriority.low,
        payload: {},
        status: QueueTaskStatus.pending,
        createdAt: DateTime(2026, 6, 25, 10, 0, 0),
        updatedAt: DateTime(2026, 6, 25, 10, 0, 0),
      );

      final t2 = QueueTask(
        id: '2',
        type: QueueTaskType.sendMessage,
        priority: QueuePriority.high,
        payload: {},
        status: QueueTaskStatus.pending,
        createdAt: DateTime(2026, 6, 25, 10, 0, 1),
        updatedAt: DateTime(2026, 6, 25, 10, 0, 1),
      );

      final t3 = QueueTask(
        id: '3',
        type: QueueTaskType.sendMessage,
        priority: QueuePriority.important,
        payload: {},
        status: QueueTaskStatus.pending,
        createdAt: DateTime(2026, 6, 25, 10, 0, 2),
        updatedAt: DateTime(2026, 6, 25, 10, 0, 2),
      );

      queue.add(t1);
      queue.add(t2);
      queue.add(t3);

      // t3 (important) should be first, then t2 (high), then t1 (low)
      expect(queue.take()?.id, equals('3'));
      expect(queue.take()?.id, equals('2'));
      expect(queue.take()?.id, equals('1'));
    });

    test('tasks with same priority are resolved FIFO', () {
      final queue = MemoryQueue();

      final t1 = QueueTask(
        id: '1',
        type: QueueTaskType.sendMessage,
        priority: QueuePriority.high,
        payload: {},
        status: QueueTaskStatus.pending,
        createdAt: DateTime(2026, 6, 25, 10, 0, 0),
        updatedAt: DateTime(2026, 6, 25, 10, 0, 0),
      );

      final t2 = QueueTask(
        id: '2',
        type: QueueTaskType.sendMessage,
        priority: QueuePriority.high,
        payload: {},
        status: QueueTaskStatus.pending,
        createdAt: DateTime(2026, 6, 25, 10, 0, 5),
        updatedAt: DateTime(2026, 6, 25, 10, 0, 5),
      );

      queue.add(t2);
      queue.add(t1);

      // t1 has earlier createdAt, so it should be taken first
      expect(queue.take()?.id, equals('1'));
      expect(queue.take()?.id, equals('2'));
    });
  });

  group('Resolvers tests', () {
    late MockQueueWorker mockWorker;
    late MockTaskResultHandler mockHandler;

    setUp(() {
      mockWorker = MockQueueWorker();
      mockHandler = MockTaskResultHandler();
      when(() => mockWorker.type).thenReturn(QueueTaskType.uploadMedia);
      when(() => mockHandler.type).thenReturn(QueueTaskType.uploadMedia);
    });

    test('QueueWorkerResolver resolves correctly', () {
      final resolver = QueueWorkerResolver([mockWorker]);

      expect(resolver.resolve(QueueTaskType.uploadMedia), equals(mockWorker));
      expect(resolver.resolve(QueueTaskType.sendMessage), isA<NullWorker>());
    });

    test('QueueResultResolver resolves correctly', () {
      final resolver = QueueResultResolver([mockHandler]);

      expect(resolver.resolve(QueueTaskType.uploadMedia), equals(mockHandler));
      expect(resolver.resolve(QueueTaskType.sendMessage), isA<NullResultHandler>());
    });
  });
}
