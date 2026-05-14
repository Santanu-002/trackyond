import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';

class NotificationController extends GetxController {
  final SyncFcmTokenUseCase _syncFcmTokenUseCase;
  final DeleteFcmTokenUseCase _deleteFcmTokenUseCase;

  final _lock = Lock();
  StreamSubscription<String>? _tokenRefreshSubscription;

  NotificationController({
    required SyncFcmTokenUseCase syncFcmTokenUseCase,
    required DeleteFcmTokenUseCase deleteFcmTokenUseCase,
  }) : _syncFcmTokenUseCase = syncFcmTokenUseCase,
       _deleteFcmTokenUseCase = deleteFcmTokenUseCase;

  @override
  void onInit() {
    super.onInit();

    // request permission
    _requestPermission();

    // Initial sync
    syncToken();

    // Listen for token refreshes
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen((_) {
          syncToken();
        });
  }

  @override
  void onClose() {
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }

  Future<void> syncToken() async {
    await _lock.synchronized(() async {
      await _syncFcmTokenUseCase(const NoParams());
    });
  }

  Future<void> deleteFcmToken() async {
    await _deleteFcmTokenUseCase(const NoParams());
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
