import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/notification/fcm_token_service.dart';
import 'package:trackyond/core/services/notification/local_notification_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
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

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INotificationDataSource>(
      () => NotificationDataSourceImpl(
        Get.find<Dio>(),
        Get.find<DeviceIdService>(),
      ),
    );

    Get.put<LocalNotificationService>(
      LocalNotificationService(),
      permanent: true,
    );

    Get.lazyPut<INotificationRepository>(
      () => NotificationRepositoryImpl(
        Get.find<INotificationDataSource>(),
        Get.find<UserService>(),
        Get.find<LocalNotificationService>(),
        Get.find<FCMTokenService>(),
      ),
    );

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

    Get.put<NotificationController>(
      NotificationController(
        syncFcmTokenUseCase: Get.find(),
        deleteFcmTokenUseCase: Get.find(),
        showLocalNotificationUseCase: Get.find(),
        getNotificationsUseCase: Get.find(),
        updateNotificationsStatusUseCase: Get.find(),
        deleteNotificationsUseCase: Get.find(),
        retryFailedAcksUseCase: Get.find(),
      ),
    );
  }
}
