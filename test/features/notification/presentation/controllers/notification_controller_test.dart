import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_notifications_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/retry_failed_acks_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/show_local_notification_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/update_notifications_status_usecase.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';

class MockSyncFcmTokenUseCase extends Mock implements SyncFcmTokenUseCase {}

class MockDeleteFcmTokenUseCase extends Mock implements DeleteFcmTokenUseCase {}

class MockShowLocalNotificationUseCase extends Mock
    implements ShowLocalNotificationUseCase {}

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockUpdateNotificationsStatusUseCase extends Mock
    implements UpdateNotificationsStatusUseCase {}

class MockDeleteNotificationsUseCase extends Mock
    implements DeleteNotificationsUseCase {}

class MockRetryFailedAcksUseCase extends Mock
    implements RetryFailedAcksUseCase {}

class FakeNotificationFilterOptions extends Fake
    implements NotificationFilterOptions {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('flutter_new_badger');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (message) async => null);

    registerFallbackValue(FakeNotificationFilterOptions());
  });

  group('NotificationController Lazy Loading', () {
    late NotificationController controller;
    late MockGetNotificationsUseCase mockGetNotificationsUseCase;

    setUp(() {
      mockGetNotificationsUseCase = MockGetNotificationsUseCase();

      // Instantiate controller directly to bypass Get.put() which might call onInit()
      // Note: We don't call onInit() to avoid Firebase bindings errors in tests
      controller = NotificationController(
        syncFcmTokenUseCase: MockSyncFcmTokenUseCase(),
        deleteFcmTokenUseCase: MockDeleteFcmTokenUseCase(),
        showLocalNotificationUseCase: MockShowLocalNotificationUseCase(),
        getNotificationsUseCase: mockGetNotificationsUseCase,
        updateNotificationsStatusUseCase:
            MockUpdateNotificationsStatusUseCase(),
        deleteNotificationsUseCase: MockDeleteNotificationsUseCase(),
        retryFailedAcksUseCase: MockRetryFailedAcksUseCase(),
      );
    });

    NotificationEntity createNotification(String id) {
      return NotificationEntity(
        id: id,
        title: 'Title $id',
        body: 'Body $id',
        createdAt: DateTime.now(),
        data: null,
      );
    }

    test(
      'fetchNotifications followed by loadMoreNotifications should append data and update hasMore',
      () async {
        // Arrange
        final firstPage = List.generate(
          50,
          (index) => createNotification('page1_$index'),
        );
        final secondPage = List.generate(
          20,
          (index) => createNotification('page2_$index'),
        );

        // Mock first page (returns 50 items, meaning hasMore should be true)
        when(() => mockGetNotificationsUseCase(any())).thenAnswer((
          invocation,
        ) async {
          final options =
              invocation.positionalArguments[0] as NotificationFilterOptions;
          if (options.offset == 0) {
            return Right(firstPage);
          } else if (options.offset == 50) {
            return Right(secondPage);
          }
          return const Right([]);
        });

        // Act - First fetch
        await controller.fetchNotifications();

        // Assert - First fetch
        expect(controller.notifications.length, 50);
        expect(controller.hasMore.value, true);

        // Act - Load more
        await controller.loadMoreNotifications();

        // Assert - Load more
        expect(controller.notifications.length, 70);
        expect(
          controller.hasMore.value,
          false,
        ); // Returned 20 items (< limit 50), so hasMore = false

        // Act - Try loading more when hasMore is false
        await controller.loadMoreNotifications();

        // Assert - No further items should be added
        expect(controller.notifications.length, 70);
      },
    );

    test(
      'loadMoreNotifications returns empty list updates hasMore to false',
      () async {
        // Arrange
        final firstPage = List.generate(
          50,
          (index) => createNotification('page1_$index'),
        );

        when(() => mockGetNotificationsUseCase(any())).thenAnswer((
          invocation,
        ) async {
          final options =
              invocation.positionalArguments[0] as NotificationFilterOptions;
          if (options.offset == 0) {
            return Right(firstPage);
          } else if (options.offset == 50) {
            return const Right([]); // Return empty list
          }
          return const Right([]);
        });

        // Act
        await controller.fetchNotifications();
        expect(controller.notifications.length, 50);
        expect(controller.hasMore.value, true);

        await controller.loadMoreNotifications();

        // Assert
        expect(controller.notifications.length, 50);
        expect(controller.hasMore.value, false);
      },
    );
  });
}
