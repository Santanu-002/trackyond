import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:trackyond/core/usecase/usecase.dart';

class NotificationController extends GetxController {
  final SyncFcmTokenUseCase _syncFcmTokenUseCase;

  NotificationController({
    required SyncFcmTokenUseCase syncFcmTokenUseCase,
  }) : _syncFcmTokenUseCase = syncFcmTokenUseCase;

  @override
  void onInit() {
    super.onInit();
    syncToken();
    
    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      syncToken();
    });
  }

  Future<void> syncToken() async {
    await _syncFcmTokenUseCase(const NoParams());
  }

  Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
