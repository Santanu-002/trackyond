import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/queue_response.dart';
import 'package:trackyond/core/services/sync/sync_service.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/send_message_response_model.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';

class MockJobChatRemoteDataSource extends Mock implements IJobChatRemoteDataSource {}
class MockJobChatLocalDataSource extends Mock implements IJobChatLocalDataSource {}
class MockWebSocketService extends Mock implements WebSocketService {}
class MockSyncService extends Mock implements SyncService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      const EnqueueTask(action: 'dummy', data: {}, requestId: 'dummy')
    );

    // Mock platform channel for Connectivity
    const channel = MethodChannel('dev.fluttercommunity.plus/connectivity');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (message) async {
        if (message.method == 'check') {
          return ['wifi']; // Represents connected state
        }
        return null;
      },
    );
  });

  late MockJobChatRemoteDataSource mockRemoteDataSource;
  late MockJobChatLocalDataSource mockLocalDataSource;
  late MockWebSocketService mockWebSocketService;
  late MockSyncService mockSyncService;
  late JobChatRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockJobChatRemoteDataSource();
    mockLocalDataSource = MockJobChatLocalDataSource();
    mockWebSocketService = MockWebSocketService();
    mockSyncService = MockSyncService();

    repository = JobChatRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockWebSocketService,
      mockSyncService,
    );

    // Default stubs
    when(() => mockLocalDataSource.saveMessages(any())).thenAnswer((_) async => {});
  });

  group('JobChatRepositoryImpl sendMessage WebSocket tests', () {
    test('sendMessage triggers WebSocket sendRequestWithResponse', () async {
      final messages = [
        SendMessageEntity(
          jobId: 'job_123',
          senderUid: 'sender_123',
          content: const [],
          type: JobChatMessageType.message,
          createdByAuthorAt: DateTime(2026, 6, 24),
          localUid: 'local_temp_123',
        )
      ];

      when(() => mockWebSocketService.isConnected).thenReturn(true);
      
      // Stub WebSocket to return a successfully matched response
      when(() => mockWebSocketService.sendRequestWithResponse(
        any(),
        event: WebSocketEvents.message,
        type: WebSocketMessageType.sendMessage,
      )).thenAnswer((invocation) async {
        final task = invocation.positionalArguments[0] as EnqueueTask;
        // Verify task gets generated with correct matched local_temp_123 requestId
        expect(task.requestId, equals('local_temp_123'));

        return QueueResponse(
          action: 'send_message',
          success: true,
          data: {
            'messages': [
              {
                'uid': 'server_uid_123',
                'localUid': 'local_temp_123',
                'jobId': 'job_123',
                'senderUid': 'sender_123',
                'type': 'message',
                'createdByAuthorAt': '2026-06-24T12:00:00Z',
                'createdAt': '2026-06-24T12:00:01Z',
                'updatedAt': '2026-06-24T12:00:01Z',
                'active': true,
                'deleted': false,
                'content': [],
              }
            ],
            'job': {
              'jobId': 'job_123',
              'jobTitle': 'Test Job',
              'customerName': 'Customer',
              'customerPhone': '1234567890',
              'workerProfileUid': 'worker_123',
              'status': 'pending',
              'requirePhotoOnStart': false,
              'requirePhotoOnComplete': false,
              'captureLocation': false,
              'createdAt': '2026-06-24T12:00:00Z',
              'allowedActions': [],
            }
          },
          requestId: task.requestId,
        );
      });

      final result = await repository.sendMessage(messages);

      expect(result.isRight(), isTrue);
      verify(() => mockLocalDataSource.saveMessages(any())).called(2); // Once for local preview, once for server response
    });

    test('sendMessage falls back to REST when WebSocket times out (demonstrating the flaw)', () async {
      final messages = [
        SendMessageEntity(
          jobId: 'job_123',
          senderUid: 'sender_123',
          content: const [],
          type: JobChatMessageType.message,
          createdByAuthorAt: DateTime(2026, 6, 24),
          localUid: 'local_temp_123',
        )
      ];

      when(() => mockWebSocketService.isConnected).thenReturn(true);
      
      // Simulate timeout exception (the flaw where requestIds do not match and WebSocket waits 8 seconds)
      when(() => mockWebSocketService.sendRequestWithResponse(
        any(),
        event: WebSocketEvents.message,
        type: WebSocketMessageType.sendMessage,
      )).thenAnswer((_) async => throw TimeoutException('WebSocket request timed out'));

      // Stub REST API fallback response
      final restResponse = SendMessageResponseModel(
        messages: [
          JobChatMessageModel(
            uid: 'local_temp_123',
            serverUid: 'server_uid_123',
            jobId: 'job_123',
            senderUid: 'sender_123',
            type: JobChatMessageType.message,
            createdByAuthorAt: DateTime(2026, 6, 24),
            createdAt: DateTime(2026, 6, 24),
            updatedAt: DateTime(2026, 6, 24),
            active: true,
            deleted: false,
            content: const [],
          )
        ],
        message: JobChatMessageModel(
          uid: 'local_temp_123',
          serverUid: 'server_uid_123',
          jobId: 'job_123',
          senderUid: 'sender_123',
          type: JobChatMessageType.message,
          createdByAuthorAt: DateTime(2026, 6, 24),
          createdAt: DateTime(2026, 6, 24),
          updatedAt: DateTime(2026, 6, 24),
          active: true,
          deleted: false,
          content: const [],
        ),
        allowedActions: const [],
      );

      final apiSuccess = ApiResponse<SendMessageResponseModel>.success(
        success: true,
        message: 'Success',
        data: restResponse,
      );

      when(() => mockRemoteDataSource.sendMessage(messages: any(named: 'messages')))
          .thenAnswer((_) async => apiSuccess);

      final result = await repository.sendMessage(messages);

      expect(result.isRight(), isTrue);
      // Verify fallback was invoked
      verify(() => mockRemoteDataSource.sendMessage(messages: any(named: 'messages'))).called(1);
    });
  });
}
