import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';

enum QueuePriority {
  high,
  normal,
  low;

  int get value {
    switch (this) {
      case QueuePriority.high:
        return 3;
      case QueuePriority.normal:
        return 2;
      case QueuePriority.low:
        return 1;
    }
  }
}

class QueueItem {
  final String id;
  final String event;
  final String type;
  final Map<String, dynamic> data;
  final QueuePriority priority;

  QueueItem({
    required this.id,
    required this.event,
    required this.type,
    required this.data,
    required this.priority,
  });
}

class PriorityQueueManager extends GetxService {
  static PriorityQueueManager get find => Get.find<PriorityQueueManager>();

  final List<QueueItem> _queue = [];
  bool _isDraining = false;
  StreamSubscription<bool>? _wsConnectionSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Get.find<Dio>();

    // Listen to WebSocket connection state changes
    _wsConnectionSubscription = Get.find<WebSocketService>().connectionStatusStream.listen((connected) {
      if (connected) {
        _drainQueue();
      }
    });

    // Listen to network status changes to check if we can drain high priority messages via HTTP when online but WS disconnected
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((result) => result != ConnectivityResult.none);
      if (isOnline) {
        _drainQueue();
      }
    });
  }

  @override
  void onClose() {
    _wsConnectionSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void enqueue({
    required String event,
    required String type,
    required Map<String, dynamic> data,
    required QueuePriority priority,
  }) {
    final item = QueueItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      event: event,
      type: type,
      data: data,
      priority: priority,
    );
    _queue.add(item);
    // Sort by priority descending so high priority is first
    _queue.sort((a, b) => b.priority.value.compareTo(a.priority.value));
    debugPrint('PriorityQueue: Enqueued event $event/$type with priority $priority. Queue size: ${_queue.length}');

    _drainQueue();
  }

  Future<void> _drainQueue() async {
    if (_isDraining || _queue.isEmpty) return;
    _isDraining = true;

    debugPrint('PriorityQueue: Starting to drain queue of size ${_queue.length}...');

    while (_queue.isNotEmpty) {
      final connectivityResults = await Connectivity().checkConnectivity();
      final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

      if (!isOnline) {
        debugPrint('PriorityQueue: Offline. Pausing draining.');
        break;
      }

      final wsService = Get.find<WebSocketService>();
      final item = _queue.first;

      if (wsService.isConnected) {
        try {
          wsService.sendEvent(item.event, item.type, item.data);
          await Future.delayed(const Duration(milliseconds: 100));
          _queue.removeAt(0);
          debugPrint('PriorityQueue: Sent item ${item.event}/${item.type} via WS. Remaining: ${_queue.length}');
        } catch (e) {
          debugPrint('PriorityQueue: Failed to send via WS: $e. Pausing draining.');
          break;
        }
      } else {
        // WebSocket is disconnected, but we are online.
        if (item.priority == QueuePriority.high) {
          try {
            final success = await _executeHttpFallback(item);
            if (success) {
              _queue.removeAt(0);
              debugPrint('PriorityQueue: Sent high-priority item ${item.event}/${item.type} via HTTP fallback. Remaining: ${_queue.length}');
            } else {
              debugPrint('PriorityQueue: HTTP fallback failed. Pausing draining.');
              break;
            }
          } catch (e) {
            debugPrint('PriorityQueue: HTTP fallback failed with error: $e. Pausing draining.');
            break;
          }
        } else {
          debugPrint('PriorityQueue: WebSocket disconnected and top item is not high-priority. Pausing draining.');
          break;
        }
      }
    }

    _isDraining = false;
    debugPrint('PriorityQueue: Finished draining. Queue size: ${_queue.length}');
  }

  Future<bool> _executeHttpFallback(QueueItem item) async {
    if (item.event == 'chat' && item.type == 'send') {
      try {
        final jobId = item.data['jobId'] as String?;
        final messagesPayload = item.data['messages'] as List?;
        if (jobId == null || messagesPayload == null) {
          debugPrint('PriorityQueue fallback: Invalid data format for chat send');
          return false;
        }

        final response = await _dio.post(
          ApiEndpoints.common.jobChatMessages(jobId),
          data: messagesPayload,
        );

        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        debugPrint('PriorityQueue fallback: Dio error: $e');
        return false;
      }
    }

    return false;
  }
}
