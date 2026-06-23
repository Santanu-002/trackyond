import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/core/services/database/tables/chat_message_table.dart';
import 'package:trackyond/core/services/database/tables/sync_queue_table.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/request/send_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';

class SyncService extends GetxService {
  final IJobChatLocalDataSource _localDataSource;
  final IJobChatRemoteDataSource _remoteDataSource;
  final UploadFileUseCase _uploadFileUseCase;
  final IDatabaseService _databaseService;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService({
    required IJobChatLocalDataSource localDataSource,
    required IJobChatRemoteDataSource remoteDataSource,
    required UploadFileUseCase uploadFileUseCase,
    required IDatabaseService databaseService,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _uploadFileUseCase = uploadFileUseCase,
        _databaseService = databaseService;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline) {
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
    while (true) {
      // Check connectivity first
      final connectivityResults = await Connectivity().checkConnectivity();
      final isOnline = connectivityResults.any((r) => r != ConnectivityResult.none);
      if (!isOnline) break;

      final tasks = await _localDataSource.getPendingSyncTasks();
      if (tasks.isEmpty) break;

      final task = tasks.first;
      final int taskId = task[SyncQueueTable.columnNames.id] as int;
      final String actionType = task[SyncQueueTable.columnNames.actionType] as String;
      final int attempts = task[SyncQueueTable.columnNames.attempts] as int? ?? 0;
      final Map<String, dynamic> payload = jsonDecode(task[SyncQueueTable.columnNames.payload] as String) as Map<String, dynamic>;

      if (attempts >= 5) {
        // Move task to a dead-letter log or simply discard to avoid poison pill loop
        await _localDataSource.deleteSyncTask(taskId);
        continue;
      }

      bool success = false;
      try {
        success = await _executeTask(actionType, payload, taskId);
      } catch (e) {
        success = false;
      }

      if (success) {
        await _localDataSource.deleteSyncTask(taskId);
      } else {
        await _localDataSource.incrementSyncTaskAttempts(taskId);
        
        // Break the loop on network failure to retry later.
        // We only continue if it was a validation failure (which increments attempts).
        final checkResults = await Connectivity().checkConnectivity();
        final checkOnline = checkResults.any((r) => r != ConnectivityResult.none);
        if (!checkOnline) {
          break;
        }
      }
    }
  }

  Future<bool> _executeTask(String actionType, Map<String, dynamic> payload, int taskId) async {
    switch (actionType) {
      case 'send_message':
        return await _handleSendMessage(payload, taskId);
      case 'delete_messages':
        return await _handleDeleteMessages(payload);
      case 'seen_messages':
        return await _handleSeenMessages(payload);
      case 'delivered_messages':
        return await _handleDeliveredMessages(payload);
      case 'update_job_status':
        return await _handleUpdateJobStatus(payload);
      default:
        // Unknown action, discard it
        return true;
    }
  }

  Future<bool> _handleSendMessage(Map<String, dynamic> payload, int taskId) async {
    final jobId = payload['jobId'] as String;
    final messagesList = payload['messages'] as List<dynamic>;
    if (messagesList.isEmpty) return true;

    final messageMap = Map<String, dynamic>.from(messagesList.first as Map<String, dynamic>);
    final messageModel = SendMessageModel.fromJson(messageMap);

    // 1. Check if any file attachments need uploading
    final updatedContent = <JobChatMessageContentModel>[];
    bool payloadChanged = false;

    for (final contentModel in messageModel.content) {
      final path = contentModel.content;
      if (path != null && _isLocalFilePath(path)) {
        final remoteUrl = await _uploadLocalFile(path);
        if (remoteUrl != null) {
          updatedContent.add(contentModel.copyWith(content: remoteUrl));
          payloadChanged = true;
        } else {
          // File upload failed, return false to retry later
          return false;
        }
      } else {
        updatedContent.add(contentModel);
      }
    }

    var finalMessageModel = messageModel;
    if (payloadChanged) {
      finalMessageModel = messageModel.copyWith(content: updatedContent);
      
      // Update local task payload so we don't upload file again on retry
      final updatedPayload = {
        'jobId': jobId,
        'messages': [finalMessageModel.toJson()],
      };
      await _databaseService.update(
        SyncQueueTable.tableName,
        {SyncQueueTable.columnNames.payload: jsonEncode(updatedPayload)},
        where: '${SyncQueueTable.columnNames.id} = ?',
        whereArgs: [taskId],
      );

      // Update the optimistic preview message in the local DB with the remote URLs
      final tempUid = messageModel.localId;
      if (tempUid != null) {
        final localMaps = await _databaseService.query(
          ChatMessageTable.tableName,
          where: '${ChatMessageTable.columnNames.uid} = ? OR ${ChatMessageTable.columnNames.localId} = ?',
          whereArgs: [tempUid, tempUid],
        );
        if (localMaps.isNotEmpty) {
          final localMessage = JobChatMessageModel.fromDbMap(localMaps.first);
          final updatedLocalMessage = localMessage.copyWith(
            content: updatedContent,
          );
          await _localDataSource.saveMessages([updatedLocalMessage]);
        }
      }
    }

    // 2. Send the message via remote data source
    final response = await _remoteDataSource.sendMessage(messages: [finalMessageModel]);
    return response.fold(
      (failure) => false,
      (data) async {
        if (data != null) {
          await _localDataSource.saveMessages(data.messages);
        }
        return true;
      },
    );
  }

  Future<bool> _handleDeleteMessages(Map<String, dynamic> payload) async {
    final jobId = payload['jobId'] as String;
    final deleteType = payload['deleteType'] as String;
    final messageUids = List<String>.from(payload['messageUids'] as List<dynamic>);
    final deletedByUserAt = DateTime.parse(payload['deletedByUserAt'] as String);

    final response = await _remoteDataSource.deleteMessages(
      jobId: jobId,
      deleteType: deleteType,
      messageUids: messageUids,
      deletedByUserAt: deletedByUserAt,
    );
    return response.fold((failure) => false, (_) => true);
  }

  Future<bool> _handleSeenMessages(Map<String, dynamic> payload) async {
    final jobId = payload['jobId'] as String;
    final messageUids = payload['messageUids'] != null
        ? List<String>.from(payload['messageUids'] as List<dynamic>)
        : null;

    final response = await _remoteDataSource.markMessagesAsSeen(
      jobId: jobId,
      messageUids: messageUids,
    );
    return response.fold((failure) => false, (_) => true);
  }

  Future<bool> _handleDeliveredMessages(Map<String, dynamic> payload) async {
    final jobId = payload['jobId'] as String;
    final messageUids = List<String>.from(payload['messageUids'] as List<dynamic>);

    final response = await _remoteDataSource.markMessagesAsDelivered(
      jobId: jobId,
      messageUids: messageUids,
    );
    return response.fold((failure) => false, (_) => true);
  }

  Future<bool> _handleUpdateJobStatus(Map<String, dynamic> payload) async {
    final jobId = payload['jobId'] as String;
    final status = payload['status'] as String;

    final response = await _remoteDataSource.updateJobStatus(
      jobId: jobId,
      status: status,
    );
    return response.fold((failure) => false, (_) => true);
  }

  bool _isLocalFilePath(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('http://') || path.startsWith('https://')) return false;
    final cleanPath = path.startsWith('file://') ? path.substring(7) : path;
    return File(cleanPath).existsSync();
  }

  Future<String?> _uploadLocalFile(String localPath) async {
    final cleanPath = localPath.startsWith('file://') ? localPath.substring(7) : localPath;
    final file = File(cleanPath);
    if (!file.existsSync()) return null;

    final params = UploadFileParams(
      file: file,
      path: 'chat_attachments/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}',
    );

    final result = await _uploadFileUseCase(params);
    return result.fold(
      (failure) => null,
      (url) => url,
    );
  }
}
