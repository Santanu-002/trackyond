import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/queue_service/queue_service.dart';

class SyncService extends GetxService {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  static SyncService get find => Get.find<SyncService>();

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline) {
        debugPrint('SyncService: Connectivity restored. Triggering QueueService run.');
        if (Get.isRegistered<QueueService>()) {
          QueueService.find.run();
        }
      }
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> triggerSync() async {
    debugPrint('SyncService: Triggering background synchronization.');
    if (Get.isRegistered<QueueService>()) {
      QueueService.find.run();
    }
  }
}
