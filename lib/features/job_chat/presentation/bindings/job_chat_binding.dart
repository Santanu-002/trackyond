import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/data/datasources/file_remote_datasource.dart';
import 'package:trackyond/core/common/data/repositories/file_repository_impl.dart';
import 'package:trackyond/core/common/domain/repositories/i_file_repository.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';

// Queue Service Imports
import 'package:trackyond/core/services/queue_service/queue_service.dart';
import 'package:trackyond/core/services/queue_service/resolver/queue_worker_resolver.dart';
import 'package:trackyond/core/services/queue_service/resolver/queue_result_resolver.dart';
import 'package:trackyond/core/services/queue_service/worker/null_worker.dart';
import 'package:trackyond/core/services/queue_service/result_handler/null_result_handler.dart';

// Workers & Handlers
import 'package:trackyond/features/job_chat/data/queue/workers/upload_media_worker.dart';
import 'package:trackyond/features/job_chat/data/queue/workers/send_message_worker.dart';
import 'package:trackyond/features/job_chat/data/queue/workers/seen_messages_worker.dart';
import 'package:trackyond/features/job_chat/data/queue/workers/delivered_messages_worker.dart';
import 'package:trackyond/features/job_chat/data/queue/workers/delete_messages_worker.dart';
import 'package:trackyond/features/job_chat/data/queue/workers/update_job_status_worker.dart';
import 'package:trackyond/features/job_chat/data/queue/result_handlers/upload_media_result_handler.dart';
import 'package:trackyond/features/job_chat/data/queue/result_handlers/send_message_result_handler.dart';
import 'package:trackyond/features/job_chat/data/queue/result_handlers/seen_messages_result_handler.dart';
import 'package:trackyond/features/job_chat/data/queue/result_handlers/delivered_messages_result_handler.dart';
import 'package:trackyond/features/job_chat/data/queue/result_handlers/delete_messages_result_handler.dart';
import 'package:trackyond/features/job_chat/data/queue/result_handlers/update_job_status_result_handler.dart';

// Datasources & Repositories
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

// Use Cases
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/update_job_status_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/listen_chat_events_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/delete_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/mark_messages_seen_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/cancel_message_upload_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/retry_message_upload_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/clear_conversation_notifications_usecase.dart';

// Controllers
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_upload_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_selection_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class JobChatBinding extends Bindings {
  @override
  void dependencies() {
    // ── File Upload dependencies ───────────────────────────────────────
    if (!Get.isRegistered<IFileRemoteDataSource>()) {
      Get.lazyPut<IFileRemoteDataSource>(() => FileRemoteDataSourceImpl(Get.find<Dio>()));
    }
    if (!Get.isRegistered<IFileRepository>()) {
      Get.lazyPut<IFileRepository>(() => FileRepositoryImpl(Get.find<IFileRemoteDataSource>()));
    }
    if (!Get.isRegistered<UploadFileUseCase>()) {
      Get.lazyPut(() => UploadFileUseCase(Get.find<IFileRepository>()));
    }

    // ── Job Chat data layer ────────────────────────────────────────────
    if (!Get.isRegistered<IJobChatRemoteDataSource>()) {
      Get.lazyPut<IJobChatRemoteDataSource>(() => JobChatRemoteDataSourceImpl(Get.find()));
    }
    if (!Get.isRegistered<IJobChatLocalDataSource>()) {
      Get.lazyPut<IJobChatLocalDataSource>(() => JobChatLocalDataSourceImpl(Get.find()));
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

    // ── Queue System dependencies ──────────────────────────────────────
    if (!Get.isRegistered<QueueService>()) {
      Get.put<QueueWorkerResolver>(
        QueueWorkerResolver([
          UploadMediaWorker(
            uploadFileUseCase: Get.find<UploadFileUseCase>(),
            eventBus: Get.find<IEventBusRepository>(),
          ),
          SendMessageWorker(
            remoteDataSource: Get.find<IJobChatRemoteDataSource>(),
            eventBus: Get.find<IEventBusRepository>(),
          ),
          SeenMessagesWorker(
            webSocketService: Get.find<WebSocketService>(),
            remoteDataSource: Get.find<IJobChatRemoteDataSource>(),
          ),
          DeliveredMessagesWorker(
            webSocketService: Get.find<WebSocketService>(),
            remoteDataSource: Get.find<IJobChatRemoteDataSource>(),
          ),
          DeleteMessagesWorker(
            webSocketService: Get.find<WebSocketService>(),
            remoteDataSource: Get.find<IJobChatRemoteDataSource>(),
          ),
          UpdateJobStatusWorker(
            remoteDataSource: Get.find<IJobChatRemoteDataSource>(),
          ),
          NullWorker(),
        ]),
      );

      Get.put<QueueResultResolver>(
        QueueResultResolver([
          UploadMediaResultHandler(
            localDataSource: Get.find<IJobChatLocalDataSource>(),
            eventBus: Get.find<IEventBusRepository>(),
          ),
          SendMessageResultHandler(
            localDataSource: Get.find<IJobChatLocalDataSource>(),
            eventBus: Get.find<IEventBusRepository>(),
          ),
          SeenMessagesResultHandler(),
          DeliveredMessagesResultHandler(),
          DeleteMessagesResultHandler(),
          UpdateJobStatusResultHandler(),
          NullResultHandler(),
        ]),
      );

      Get.put<QueueService>(
        QueueService(
          databaseService: Get.find<IDatabaseService>(),
          workerResolver: Get.find<QueueWorkerResolver>(),
          resultResolver: Get.find<QueueResultResolver>(),
        ),
      );
    }

    // ── Job Chat use cases ─────────────────────────────────────────────
    Get.lazyPut(() => GetJobMessagesUseCase(Get.find()));
    Get.lazyPut(() => SendMessageUseCase(Get.find()));
    Get.lazyPut(() => UpdateJobStatusUseCase(Get.find()));
    Get.lazyPut(() => GetJobChatMembersUseCase(Get.find()));
    Get.lazyPut(() => ListenChatEventsUseCase(Get.find()));
    Get.lazyPut(() => DeleteMessagesUseCase(Get.find()));
    Get.lazyPut(() => MarkMessagesSeenUseCase(Get.find()));
    Get.lazyPut(() => CancelMessageUploadUseCase(Get.find()));
    Get.lazyPut(() => RetryMessageUploadUseCase(Get.find()));
    Get.lazyPut(() => ClearConversationNotificationsUseCase(Get.find<INotificationRepository>()));

    // ── Controllers ─────────────────────────────────────────────────────
    Get.put(JobChatAttachmentController());
    Get.put(JobChatUploadController(uploadFileUseCase: Get.find()));
    Get.put(JobChatSelectionController(deleteMessagesUseCase: Get.find()));
    Get.put(JobChatActionController(sendMessageUseCase: Get.find()));

    Get.lazyPut(
      () => JobChatController(
        getMessagesUseCase: Get.find(),
        sendMessageUseCase: Get.find(),
        getChatMembersUseCase: Get.find(),
        listenChatEventsUseCase: Get.find(),
        markMessagesSeenUseCase: Get.find(),
        clearConversationNotificationsUseCase: Get.find(),
        cancelMessageUploadUseCase: Get.find(),
        retryMessageUploadUseCase: Get.find(),
      ),
    );
  }
}
