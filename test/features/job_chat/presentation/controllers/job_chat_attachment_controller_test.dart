import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/data/models/response/media_preview_item.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class MockJobChatController extends Mock implements JobChatController {}
class MockJobChatActionController extends Mock implements JobChatActionController {}
class MockJobChatMessageEntity extends Mock implements JobChatMessageEntity {}
class FakeJobChatMessageEntity extends Fake implements JobChatMessageEntity {}

void main() {
  late MockJobChatController mockChatController;
  late MockJobChatActionController mockActionController;
  late JobChatAttachmentController attachmentController;

  setUpAll(() {
    registerFallbackValue(MediaPreviewType.image);
    registerFallbackValue(FakeJobChatMessageEntity());
  });

  void stubGetxLifecycle(GetxController mock) {
    when(() => mock.onStart).thenReturn(InternalFinalCallback<void>(callback: () {}));
    when(() => mock.onDelete).thenReturn(InternalFinalCallback<void>(callback: () {}));
  }

  setUp(() {
    mockChatController = MockJobChatController();
    mockActionController = MockJobChatActionController();
    attachmentController = JobChatAttachmentController();

    stubGetxLifecycle(mockChatController);
    stubGetxLifecycle(mockActionController);

    Get.testMode = true;
    Get.put<JobChatController>(mockChatController);
    Get.put<JobChatActionController>(mockActionController);
    Get.put<JobChatAttachmentController>(attachmentController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('JobChatAttachmentController - attachFromCamera returning items directly', (tester) async {
    final testItem = MediaPreviewItem(
      path: 'test_path',
      type: JobChatMessageContentType.image,
      metadata: const ChatMessageMetadataModel(),
    );

    when(() => mockChatController.sendMediaMessagesBackground(
      any(),
      replyingTo: any(named: 'replyingTo'),
      caption: any(named: 'caption'),
    )).thenAnswer((_) async {});

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/chat',
        getPages: [
          GetPage(
            name: '/chat',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
          GetPage(
            name: '/camera',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      ),
    );

    // Start the camera flow
    attachmentController.attachFromCamera();
    await tester.pumpAndSettle();

    // Verify it navigated to camera page
    expect(Get.currentRoute, '/camera');

    // Simulate clicking send in preview inside the camera flow, which pops camera returning result
    Get.back(result: {
      'items': [testItem],
      'caption': 'test_caption',
    });
    await tester.pumpAndSettle();

    // Verify it navigated back to chat
    expect(Get.currentRoute, '/chat');

    // Verify correct send logic was triggered
    verify(() => mockChatController.sendMediaMessagesBackground(
      [testItem],
      replyingTo: null,
      caption: 'test_caption',
    )).called(1);
  });

  testWidgets('JobChatAttachmentController - attachFromCamera returning path (skipped preview)', (tester) async {
    final testItem = MediaPreviewItem(
      path: 'test_path',
      type: JobChatMessageContentType.image,
      metadata: const ChatMessageMetadataModel(),
    );

    when(() => mockChatController.sendMediaMessagesBackground(
      any(),
      replyingTo: any(named: 'replyingTo'),
      caption: any(named: 'caption'),
    )).thenAnswer((_) async {});

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/chat',
        getPages: [
          GetPage(
            name: '/chat',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
          GetPage(
            name: '/camera',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
          GetPage(
            name: '/media-preview',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      ),
    );

    // Start flow
    attachmentController.attachFromCamera();
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/camera');

    // Return raw path (simulating skipPreview: true or similar raw path return)
    Get.back(result: {
      'path': 'test_path',
    });
    await tester.pumpAndSettle();

    // Should have auto-navigated to media-preview
    expect(Get.currentRoute, startsWith('/media-preview'));

    // Simulate sending from preview page
    Get.back(result: {
      'items': [testItem],
      'caption': 'test_caption',
    });
    await tester.pumpAndSettle();

    // Returned to chat
    expect(Get.currentRoute, '/chat');

    verify(() => mockChatController.sendMediaMessagesBackground(
      [testItem],
      replyingTo: null,
      caption: 'test_caption',
    )).called(1);
  });

  testWidgets('JobChatAttachmentController - executeActionWithMedia', (tester) async {
    final testItem = MediaPreviewItem(
      path: 'test_path',
      type: JobChatMessageContentType.image,
      metadata: const ChatMessageMetadataModel(),
    );

    when(() => mockActionController.executeActionWithMedia(
      actionString: any(named: 'actionString'),
      mediaPaths: any(named: 'mediaPaths'),
      caption: any(named: 'caption'),
    )).thenAnswer((_) async => true);

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/chat',
        getPages: [
          GetPage(
            name: '/chat',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
          GetPage(
            name: '/media-preview',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      ),
    );

    attachmentController.navigateToMediaPreview(
      imagePath: 'test_path',
      type: MediaPreviewType.image,
    );
    await tester.pumpAndSettle();

    expect(Get.currentRoute, startsWith('/media-preview'));

    // Pop with action
    Get.back(result: {
      'items': [testItem],
      'caption': 'action_caption',
      'action': 'start_job',
    });
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/chat');

    verify(() => mockActionController.executeActionWithMedia(
      actionString: 'start_job',
      mediaPaths: ['test_path'],
      caption: 'action_caption',
    )).called(1);
  });

  testWidgets('JobChatAttachmentController - sendMediaStatusProof', (tester) async {
    final testItem = MediaPreviewItem(
      path: 'test_path',
      type: JobChatMessageContentType.image,
      metadata: const ChatMessageMetadataModel(),
    );
    final mockMessage = MockJobChatMessageEntity();

    when(() => mockActionController.sendMediaStatusProof(
      imagePaths: any(named: 'imagePaths'),
      caption: any(named: 'caption'),
      requestMessage: any(named: 'requestMessage'),
    )).thenAnswer((_) async => true);

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/chat',
        getPages: [
          GetPage(
            name: '/chat',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
          GetPage(
            name: '/media-preview',
            page: () => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      ),
    );

    attachmentController.navigateToMediaPreview(
      imagePath: 'test_path',
      type: MediaPreviewType.image,
      requestMessage: mockMessage,
    );
    await tester.pumpAndSettle();

    expect(Get.currentRoute, startsWith('/media-preview'));

    // Pop with requestMessage
    Get.back(result: {
      'items': [testItem],
      'caption': 'proof_caption',
      'requestMessage': mockMessage,
    });
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/chat');

    verify(() => mockActionController.sendMediaStatusProof(
      imagePaths: ['test_path'],
      caption: 'proof_caption',
      requestMessage: mockMessage,
    )).called(1);
  });
}
