import 'dart:io';
import 'package:dio/dio.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';

class UploadMediaWorker implements QueueWorker {
  final UploadFileUseCase _uploadFileUseCase;
  final IEventBusRepository _eventBus;

  UploadMediaWorker({
    required UploadFileUseCase uploadFileUseCase,
    required IEventBusRepository eventBus,
  })  : _uploadFileUseCase = uploadFileUseCase,
        _eventBus = eventBus;

  @override
  QueueTaskType get type => QueueTaskType.uploadMedia;

  @override
  Future<WorkResult> execute(QueueTask task) async {
    final cancelToken = QueueWorkerCancelTracker.getOrCreate(task.id);

    final payload = task.payload as Map<String, dynamic>;
    final jobId = payload['jobId'] as String;
    final items = List<Map<String, dynamic>>.from(payload['items'] as List);

    final List<String> remotePaths = [];
    bool anyFailed = false;
    String errorMessage = 'Upload failed';

    try {
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final localPath = item['path'] as String;
        final file = File(localPath);

        if (!await file.exists()) {
          anyFailed = true;
          errorMessage = 'Local file does not exist: $localPath';
          break;
        }

        final uploadResult = await _uploadFileUseCase(
          UploadFileParams(
            file: file,
            path: jobId,
            cancelToken: cancelToken,
            onSendProgress: (sent, total) {
              if (total > 0 && !cancelToken.isCancelled) {
                final fileProgress = sent / total;
                final overallProgress = (i + fileProgress) / items.length;
                _eventBus.fire(ChatUploadProgressEvent(task.id, overallProgress));
              }
            },
          ),
        );

        if (cancelToken.isCancelled) {
          QueueWorkerCancelTracker.remove(task.id);
          _eventBus.fire(ChatUploadErrorEvent(task.id, 'Cancelled'));
          return WorkResult.failure(task: task, message: 'Cancelled');
        }

        final remotePath = uploadResult.fold(
          (failure) {
            errorMessage = failure.message;
            return null;
          },
          (path) => path,
        );

        if (remotePath == null) {
          anyFailed = true;
          break;
        }

        remotePaths.add(remotePath);
      }

      QueueWorkerCancelTracker.remove(task.id);

      if (anyFailed) {
        _eventBus.fire(ChatUploadErrorEvent(task.id, errorMessage));
        return WorkResult.failure(task: task, message: errorMessage);
      }

      return WorkResult.success(
        task: task,
        message: 'Upload completed',
        data: {'remotePaths': remotePaths},
      );
    } catch (e) {
      QueueWorkerCancelTracker.remove(task.id);
      final isCancel = cancelToken.isCancelled || (e is DioException && e.type == DioExceptionType.cancel);
      final msg = isCancel ? 'Cancelled' : e.toString();
      _eventBus.fire(ChatUploadErrorEvent(task.id, msg));
      return WorkResult.failure(task: task, message: msg);
    }
  }
}
