import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/sync/models/sync_command.dart';
import 'package:trackyond/core/services/sync/models/sync_result.dart';
import 'package:trackyond/core/services/sync/models/sync_task.dart';
import 'package:trackyond/core/services/sync/queue/i_sync_queue.dart';
import 'package:trackyond/core/services/sync/worker/sync_worker.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/sync_priority.dart';

class SyncService extends GetxService {
  final ISyncQueue _syncQueue;
  static final Map<Type, SyncCommandHandler<SyncCommand>> _handlers = {};
  static final Map<String, SyncCommand Function(Map<String, dynamic> json)> _deserializers = {};

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService({
    required ISyncQueue syncQueue,
  }) : _syncQueue = syncQueue;

  static SyncService get find => Get.find<SyncService>();

  static void registerCommand<T extends SyncCommand>({
    required String actionType,
    required T Function(Map<String, dynamic> json) deserializer,
    required SyncCommandHandler<T> handler,
  }) {
    _deserializers[actionType] = (json) => deserializer(json);
    _handlers[T] = handler as SyncCommandHandler<SyncCommand>;
    debugPrint('SyncService: Registered command "$actionType" with type "$T"');
  }

  static SyncCommandHandler<SyncCommand>? getHandler(Type commandType) {
    return _handlers[commandType];
  }

  static SyncCommand deserializeCommand(String actionType, Map<String, dynamic> payload) {
    final deserializer = _deserializers[actionType];
    if (deserializer == null) {
      throw ArgumentError('Unknown action type: $actionType');
    }
    return deserializer(payload);
  }

  Future<void> enqueue(SyncCommand command, {SyncPriority priority = SyncPriority.normal}) async {
    final task = EnqueueTask.fromCommand(command);
    await _syncQueue.enqueue(task, priority: priority);
    triggerSync();
  }


  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline) {
        debugPrint('SyncService: Connectivity restored. Triggering sync.');
        triggerSync();
      }
    });
    // Trigger initial sync on startup
    triggerSync();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await _processQueue();
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processQueue() async {
    final worker = SyncWorker(_syncQueue);

    while (true) {
      // 1. Check network connectivity before peeking/processing tasks
      final connectivityResults = await Connectivity().checkConnectivity();
      final isOnline = connectivityResults.any((r) => r != ConnectivityResult.none);
      if (!isOnline) {
        debugPrint('SyncService: Offline. Pausing queue processing.');
        break;
      }

      // 2. Fetch pending tasks
      final List<SyncTask> tasks = await _syncQueue.getPendingTasks();
      if (tasks.isEmpty) {
        debugPrint('SyncService: Queue is empty.');
        break;
      }

      final task = tasks.first;

      // Poison pill prevention
      if (task.attempts >= 5) {
        debugPrint('SyncService: Task ${task.id} (${task.enqueueTask.action}) exceeded max retry attempts. Discarding.');
        await _syncQueue.deleteTask(task.id);
        continue;
      }

      // 3. Process the task
      final result = await worker.processTask(task);

      if (result is SyncRetry) {
        // If a task requests a retry, it means a temporary failure occurred.
        // We pause queue processing to prevent processing subsequent tasks out of order.
        debugPrint('SyncService: Temporary failure detected. Pausing queue processing.');
        break;
      }
    }
  }
}
