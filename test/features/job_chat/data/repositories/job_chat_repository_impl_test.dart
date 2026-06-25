import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/core/services/queue_service/queue_service.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/common/enums/queue_priority.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';

class MockJobChatRemoteDataSource extends Mock implements IJobChatRemoteDataSource {}
class MockJobChatLocalDataSource extends Mock implements IJobChatLocalDataSource {}
class MockWebSocketService extends Mock implements WebSocketService {}
class MockQueueService extends Mock implements QueueService {
  @override
  InternalFinalCallback<void> get onStart => InternalFinalCallback<void>(callback: () {});
  @override
  InternalFinalCallback<void> get onDelete => InternalFinalCallback<void>(callback: () {});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(QueueTask(
      id: 'fallback_id',
      type: QueueTaskType.none,
      priority: QueuePriority.low,
      payload: const {},
      status: QueueTaskStatus.pending,
      createdAt: DateTime(2026, 6, 24),
      updatedAt: DateTime(2026, 6, 24),
    ));
  });

  late MockJobChatRemoteDataSource mockRemoteDataSource;
  late MockJobChatLocalDataSource mockLocalDataSource;
  late MockWebSocketService mockWebSocketService;
  late MockQueueService mockQueueService;
  late JobChatRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockJobChatRemoteDataSource();
    mockLocalDataSource = MockJobChatLocalDataSource();
    mockWebSocketService = MockWebSocketService();
    mockQueueService = MockQueueService();

    Get.put<QueueService>(mockQueueService);

    repository = JobChatRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockWebSocketService,
    );

    // Default stubs
    when(() => mockLocalDataSource.saveMessages(any())).thenAnswer((_) async => {});
    when(() => mockQueueService.enqueue(any())).thenAnswer((_) async => {});
  });

  tearDown(() {
    Get.reset();
  });

  group('JobChatRepositoryImpl sendMessage Queue Routing tests', () {
    test('sendMessage with plain text enqueues SendMessage QueueTask', () async {
      final messages = [
        SendMessageEntity(
          jobId: 'job_123',
          senderUid: 'sender_123',
          content: const [
            JobChatMessageContentEntity(
              type: JobChatMessageContentType.text,
              content: 'Hello world',
            ),
          ],
          type: JobChatMessageType.message,
          createdByAuthorAt: DateTime(2026, 6, 24),
          localUid: 'local_temp_123',
        )
      ];

      final result = await repository.sendMessage(messages);

      expect(result.isRight(), isTrue);

      // Verify local database save
      verify(() => mockLocalDataSource.saveMessages(any())).called(1);

      // Verify QueueService enqueue
      final capturedTasks = verify(() => mockQueueService.enqueue(captureAny())).captured;

      expect(capturedTasks.first, isA<QueueTask>());
      final task = capturedTasks.first as QueueTask;
      expect(task.type, equals(QueueTaskType.sendMessage));
      expect(task.priority, equals(QueuePriority.high));
      expect(task.id, equals('local_temp_123'));
      expect(task.payload['jobId'], equals('job_123'));
    });

    test('sendMessage with media enqueues UploadMedia QueueTask', () async {
      final messages = [
        SendMessageEntity(
          jobId: 'job_123',
          senderUid: 'sender_123',
          content: const [
            JobChatMessageContentEntity(
              type: JobChatMessageContentType.image,
              content: 'local/path/to/image.jpg',
            ),
            JobChatMessageContentEntity(
              type: JobChatMessageContentType.text,
              content: 'caption text',
            ),
          ],
          type: JobChatMessageType.message,
          createdByAuthorAt: DateTime(2026, 6, 24),
          localUid: 'local_temp_123',
        )
      ];

      final result = await repository.sendMessage(messages);

      expect(result.isRight(), isTrue);

      // Verify local database save
      verify(() => mockLocalDataSource.saveMessages(any())).called(1);

      // Verify QueueService enqueue
      final capturedTasks = verify(() => mockQueueService.enqueue(captureAny())).captured;

      expect(capturedTasks.first, isA<QueueTask>());
      final task = capturedTasks.first as QueueTask;
      expect(task.type, equals(QueueTaskType.uploadMedia));
      expect(task.priority, equals(QueuePriority.high));
      expect(task.id, equals('local_temp_123'));
      expect(task.payload['jobId'], equals('job_123'));
      final items = List<Map<String, dynamic>>.from(task.payload['items'] as List);
      expect(items.length, equals(1));
      expect(items.first['path'], equals('local/path/to/image.jpg'));
      expect(task.payload['caption'], equals('caption text'));
    });
  });
}
