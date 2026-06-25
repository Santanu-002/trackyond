import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/listen_chat_events_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/mark_messages_seen_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/cancel_message_upload_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/retry_message_upload_usecase.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_selection_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';
import 'package:trackyond/features/job_chat/domain/usecases/clear_conversation_notifications_usecase.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/chat_item.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_upload_controller.dart';

class MockGetJobMessagesUseCase extends Mock implements GetJobMessagesUseCase {}
class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}
class MockGetJobChatMembersUseCase extends Mock implements GetJobChatMembersUseCase {}
class MockListenChatEventsUseCase extends Mock implements ListenChatEventsUseCase {}
class MockMarkMessagesSeenUseCase extends Mock implements MarkMessagesSeenUseCase {}
class MockClearConversationNotificationsUseCase extends Mock implements ClearConversationNotificationsUseCase {}
class MockCancelMessageUploadUseCase extends Mock implements CancelMessageUploadUseCase {}
class MockRetryMessageUploadUseCase extends Mock implements RetryMessageUploadUseCase {}
class MockAuthController extends Mock implements AuthController {}

class MockJobChatAttachmentController extends Mock implements JobChatAttachmentController {}
class MockJobChatUploadController extends Mock implements JobChatUploadController {}
class MockJobChatSelectionController extends Mock implements JobChatSelectionController {}
class MockJobChatActionController extends Mock implements JobChatActionController {}

class FakeGetJobMessagesParams extends Fake implements GetJobMessagesParams {}
class FakeMarkMessagesSeenParams extends Fake implements MarkMessagesSeenParams {}
class FakeNoParams extends Fake implements NoParams {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    Get.testMode = true;
    registerFallbackValue(FakeGetJobMessagesParams());
    registerFallbackValue(FakeMarkMessagesSeenParams());
    registerFallbackValue(FakeNoParams());
  });

  group('JobChatController Unit Tests', () {
    late MockGetJobMessagesUseCase mockMessagesUseCase;
    late MockSendMessageUseCase mockSendMessageUseCase;
    late MockGetJobChatMembersUseCase mockMembersUseCase;
    late MockListenChatEventsUseCase mockListenEventsUseCase;
    late MockMarkMessagesSeenUseCase mockMarkSeenUseCase;
    late MockClearConversationNotificationsUseCase mockClearNotificationsUseCase;
    late MockCancelMessageUploadUseCase mockCancelUploadUseCase;
    late MockRetryMessageUploadUseCase mockRetryUploadUseCase;
    late MockAuthController mockAuthController;

    late JobChatController controller;
    late JobEntity testJob;

    void stubGetxLifecycle(GetxController mock) {
      when(() => mock.onStart).thenReturn(InternalFinalCallback<void>(callback: () {}));
      when(() => mock.onDelete).thenReturn(InternalFinalCallback<void>(callback: () {}));
    }

    setUp(() {
      Get.reset();
      Get.testMode = true;

      mockMessagesUseCase = MockGetJobMessagesUseCase();
      mockSendMessageUseCase = MockSendMessageUseCase();
      mockMembersUseCase = MockGetJobChatMembersUseCase();
      mockListenEventsUseCase = MockListenChatEventsUseCase();
      mockMarkSeenUseCase = MockMarkMessagesSeenUseCase();
      mockClearNotificationsUseCase = MockClearConversationNotificationsUseCase();
      mockCancelUploadUseCase = MockCancelMessageUploadUseCase();
      mockRetryUploadUseCase = MockRetryMessageUploadUseCase();
      mockAuthController = MockAuthController();

      // Mock sub-controllers
      final mockAttachment = MockJobChatAttachmentController();
      final mockUpload = MockJobChatUploadController();
      final mockSelection = MockJobChatSelectionController();
      final mockAction = MockJobChatActionController();

      stubGetxLifecycle(mockAttachment);
      stubGetxLifecycle(mockUpload);
      stubGetxLifecycle(mockSelection);
      stubGetxLifecycle(mockAction);
      stubGetxLifecycle(mockAuthController);

      Get.put<JobChatAttachmentController>(mockAttachment);
      Get.put<JobChatUploadController>(mockUpload);
      Get.put<JobChatSelectionController>(mockSelection);
      Get.put<JobChatActionController>(mockAction);
      Get.put<AuthController>(mockAuthController);

      testJob = JobEntity(
        jobId: 'job_123',
        jobTitle: 'Fix Plumbing',
        customerName: 'John Doe',
        customerPhone: '1234567890',
        workerProfileUid: 'worker_uid',
        status: JobStatus.pending,
        requirePhotoOnStart: false,
        requirePhotoOnComplete: false,
        captureLocation: false,
        createdAt: DateTime.now(),
      );

      Get.routing.args = testJob;

      // Mock setup responses
      when(() => mockMessagesUseCase(any())).thenAnswer((_) async => const Right([]));
      when(() => mockMembersUseCase(any())).thenAnswer((_) async => const Right([]));
      when(() => mockMarkSeenUseCase(any())).thenAnswer((_) async => const Right(unit));
      when(() => mockClearNotificationsUseCase(any())).thenAnswer((_) async => const Right(unit));
      when(() => mockListenEventsUseCase(any())).thenAnswer((_) async => Right(Stream.empty()));
      when(() => mockAuthController.profile).thenAnswer((_) async => const MemberProfile(
        uid: 'my_profile_uid',
        userUid: 'my_user_uid',
        name: 'My Profile',
        phone: '1234567890',
        designation: 'Developer',
      ));
      when(() => mockAuthController.user).thenAnswer((_) async => User(
        uid: 'my_user_uid',
        phone: '1234567890',
        role: UserRole.worker,
        isNewUser: false,
      ));
      when(() => mockAuthController.userRole).thenAnswer((_) async => null);

      controller = JobChatController(
        getMessagesUseCase: mockMessagesUseCase,
        sendMessageUseCase: mockSendMessageUseCase,
        getChatMembersUseCase: mockMembersUseCase,
        listenChatEventsUseCase: mockListenEventsUseCase,
        markMessagesSeenUseCase: mockMarkSeenUseCase,
        clearConversationNotificationsUseCase: mockClearNotificationsUseCase,
        cancelMessageUploadUseCase: mockCancelUploadUseCase,
        retryMessageUploadUseCase: mockRetryUploadUseCase,
      );
    });

    test('unreadCount counts unread messages correctly', () async {
      final messages = [
        JobChatMessageEntity(
          uid: 'msg_1',
          jobId: 'job_123',
          senderUid: 'other_user',
          content: const [],
          createdByAuthorAt: DateTime.now(),
          isMe: false,
          seenAt: null, // Unread
        ),
        JobChatMessageEntity(
          uid: 'msg_2',
          jobId: 'job_123',
          senderUid: 'my_profile_uid', // Sent by me
          content: const [],
          createdByAuthorAt: DateTime.now(),
          isMe: true,
          seenAt: null,
        ),
        JobChatMessageEntity(
          uid: 'msg_3',
          jobId: 'job_123',
          senderUid: 'other_user',
          content: const [],
          createdByAuthorAt: DateTime.now(),
          isMe: false,
          seenAt: DateTime.now(), // Already read
        ),
      ];
      when(() => mockMessagesUseCase(any())).thenAnswer((_) async => Right(messages));

      // Initialize controller
      controller.onInit();
      await Future.delayed(Duration.zero);

      expect(controller.unreadCount, equals(1));
    });

    test('initialScrollIndex and initialScrollAlignment default when no unread divider', () async {
      final messages = [
        JobChatMessageEntity(
          uid: 'msg_1',
          jobId: 'job_123',
          senderUid: 'my_profile_uid',
          content: const [],
          createdByAuthorAt: DateTime.now(),
          isMe: true,
        ),
      ];
      when(() => mockMessagesUseCase(any())).thenAnswer((_) async => Right(messages));

      controller.onInit();
      await Future.delayed(Duration.zero);

      expect(controller.initialScrollIndex, equals(0));
      expect(controller.initialScrollAlignment, equals(0.0));
    });

    test('initialScrollIndex and initialScrollAlignment set correctly when unread divider is present', () async {
      final messages = [
        JobChatMessageEntity(
          uid: 'msg_1',
          jobId: 'job_123',
          senderUid: 'other_user',
          content: const [],
          createdByAuthorAt: DateTime.now(),
          isMe: false,
          seenAt: null,
        ),
      ];
      when(() => mockMessagesUseCase(any())).thenAnswer((_) async => Right(messages));

      controller.onInit();
      await Future.delayed(Duration.zero);

      final items = controller.flattenedItems;
      final dividerIndex = items.indexWhere((item) => item is ChatUnreadDividerItem);

      expect(dividerIndex, isNot(-1));
      expect(controller.initialScrollIndex, equals(dividerIndex));
      expect(controller.initialScrollAlignment, equals(0.3));
    });

    test('incoming messages from others are cached in pendingMessages when isNearBottom is false', () async {
      final eventController = StreamController<ChatEvent>();
      when(() => mockListenEventsUseCase(any())).thenAnswer((_) async => Right(eventController.stream));

      controller.onInit();
      await Future.delayed(Duration.zero);

      // Simulate scrolled up
      controller.isNearBottom.value = false;

      final incomingMsg = JobChatMessageEntity(
        uid: 'new_msg',
        jobId: 'job_123',
        senderUid: 'other_user',
        content: const [],
        createdByAuthorAt: DateTime.now(),
        isMe: false,
      );

      eventController.add(ChatMessageReceivedEvent(incomingMsg));
      await Future.delayed(Duration.zero);

      // Verify that it went to pendingMessages and not messages list
      expect(controller.pendingMessages.length, equals(1));
      expect(controller.messages.length, equals(0));
      expect(controller.pendingMessages.first.uid, equals('new_msg'));

      // Now scroll to bottom / call scrollToLast
      controller.scrollToLast();
      
      // Verify pendingMessages are flushed into messages
      expect(controller.pendingMessages.length, equals(0));
      expect(controller.messages.length, equals(1));
      expect(controller.messages.first.uid, equals('new_msg'));

      await eventController.close();
    });
  });
}
