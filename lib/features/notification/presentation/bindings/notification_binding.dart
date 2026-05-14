import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/notification/fcm_token_service.dart';
import 'package:trackyond/core/services/notification/local_notification_service.dart';
import 'package:trackyond/core/services/notification/notification_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/notification/data/datasources/notification_data_source.dart';
import 'package:trackyond/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/show_local_notification_usecase.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<INotificationDataSource>(
      NotificationDataSourceImpl(Get.find<Dio>(), Get.find<DeviceIdService>()),
    );

    Get.put<FCMTokenService>(
      FCMTokenService(Get.find<SharedPreferences>()),
    );

    final localNotificationService = LocalNotificationService();
    localNotificationService.init();
    Get.put<LocalNotificationService>(
      localNotificationService,
    );

    Get.put<NotificationService>(
      NotificationService(),
    );

    Get.put<INotificationRepository>(
      NotificationRepositoryImpl(
        Get.find<FCMTokenService>(),
        Get.find<INotificationDataSource>(),
        Get.find<UserService>(),
        Get.find<LocalNotificationService>(),
      ),
    );

    Get.put<SyncFcmTokenUseCase>(
      SyncFcmTokenUseCase(Get.find<INotificationRepository>()),
    );

    Get.put<DeleteFcmTokenUseCase>(
      DeleteFcmTokenUseCase(Get.find<INotificationRepository>()),
    );

    Get.put<ShowLocalNotificationUseCase>(
      ShowLocalNotificationUseCase(Get.find<INotificationRepository>()),
    );

    Get.put<NotificationController>(
      NotificationController(
        syncFcmTokenUseCase: Get.find(),
        deleteFcmTokenUseCase: Get.find(),
        showLocalNotificationUseCase: Get.find(),
      ),
    );

  }
}
