import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/services/notification/fcm_token_service.dart';
import 'package:trackyond/core/services/notification/local_notification_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/job_chat/domain/usecases/emit_chat_message_received_use_case.dart';
import 'package:trackyond/core/services/notification/background_ack_service.dart';
import 'package:trackyond/features/notification/data/datasources/notification_data_source.dart';
import 'package:trackyond/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_notifications_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/retry_failed_acks_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/show_local_notification_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/update_notifications_status_usecase.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';

import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';
import 'package:trackyond/features/worker/dashboard/data/repositories/job_repository_impl.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_remote_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_local_datasource.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/save_jobs_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/save_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/clear_conversation_notifications_usecase.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INotificationDataSource>(
      () => NotificationDataSourceImpl(
        Get.find<Dio>(),
      ),
    );

    if (!Get.isRegistered<LocalNotificationService>()) {
      Get.put<LocalNotificationService>(
        LocalNotificationService(),
        permanent: true,
      );
    }

    Get.lazyPut<INotificationRepository>(
      () => NotificationRepositoryImpl(
        Get.find<INotificationDataSource>(),
        Get.find<UserService>(),
        Get.find<LocalNotificationService>(),
        Get.find<FCMTokenService>(),
        Get.find<BackgroundAckService>(),
      ),
    );

    // Register Job and JobChat repository dependencies if not already registered
    if (!Get.isRegistered<IJobRepository>()) {
      Get.lazyPut<IJobRemoteDataSource>(() => JobRemoteDataSourceImpl(Get.find<Dio>()));
      Get.lazyPut<IJobRepository>(
        () => JobRepositoryImpl(
          Get.find<IJobRemoteDataSource>(),
          Get.find<IJobLocalDataSource>(),
        ),
      );
    }

    if (!Get.isRegistered<IJobChatRepository>()) {
      Get.lazyPut<IJobChatRepository>(
        () => JobChatRepositoryImpl(
          Get.find<IJobChatRemoteDataSource>(),
          Get.find<IJobChatLocalDataSource>(),
          Get.find<WebSocketService>(),
        ),
      );
    }

    Get.lazyPut<SyncFcmTokenUseCase>(
      () => SyncFcmTokenUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<DeleteFcmTokenUseCase>(
      () => DeleteFcmTokenUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<ShowLocalNotificationUseCase>(
      () => ShowLocalNotificationUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<UpdateNotificationsStatusUseCase>(
      () =>
          UpdateNotificationsStatusUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<DeleteNotificationsUseCase>(
      () => DeleteNotificationsUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<RetryFailedAcksUseCase>(
      () => RetryFailedAcksUseCase(Get.find<INotificationRepository>()),
    );

    Get.lazyPut<EmitChatMessageReceivedUseCase>(
      () => EmitChatMessageReceivedUseCase(Get.find<IEventBusRepository>()),
    );

    // Register new UseCases
    Get.lazyPut<SaveJobsUseCase>(
      () => SaveJobsUseCase(Get.find<IJobRepository>()),
    );

    Get.lazyPut<SaveMessagesUseCase>(
      () => SaveMessagesUseCase(Get.find<IJobChatRepository>()),
    );

    Get.lazyPut<MarkMessagesAsDeliveredUseCase>(
      () => MarkMessagesAsDeliveredUseCase(Get.find<IJobChatRepository>()),
    );

    Get.lazyPut<ClearConversationNotificationsUseCase>(
      () => ClearConversationNotificationsUseCase(Get.find<INotificationRepository>()),
    );

    Get.put<NotificationController>(
      NotificationController(
        syncFcmTokenUseCase: Get.find(),
        deleteFcmTokenUseCase: Get.find(),
        showLocalNotificationUseCase: Get.find(),
        getNotificationsUseCase: Get.find(),
        updateNotificationsStatusUseCase: Get.find(),
        deleteNotificationsUseCase: Get.find(),
        retryFailedAcksUseCase: Get.find(),
        emitChatMessageReceivedUseCase: Get.find(),
        saveJobsUseCase: Get.find(),
        saveMessagesUseCase: Get.find(),
        markMessagesAsDeliveredUseCase: Get.find(),
        clearConversationNotificationsUseCase: Get.find(),
      ),
    );
  }
}
