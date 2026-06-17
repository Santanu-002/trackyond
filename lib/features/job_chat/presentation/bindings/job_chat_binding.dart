import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/data/datasources/file_remote_datasource.dart';
import 'package:trackyond/core/common/data/repositories/file_repository_impl.dart';
import 'package:trackyond/core/common/domain/repositories/i_file_repository.dart';
import 'package:trackyond/core/common/domain/usecase/upload_file_usecase.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/update_job_status_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/emit_job_update_use_case.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_upload_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_selection_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';
import 'package:trackyond/features/job_chat/domain/usecases/listen_chat_events_use_case.dart';
import 'package:trackyond/features/job_chat/domain/usecases/delete_messages_usecase.dart';

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
    Get.lazyPut<IJobChatDataSource>(() => JobChatRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<IJobChatRepository>(() => JobChatRepositoryImpl(Get.find()));

    // ── Job Chat use cases ─────────────────────────────────────────────
    Get.lazyPut(() => GetJobMessagesUseCase(Get.find()));
    Get.lazyPut(() => SendMessageUseCase(Get.find()));
    Get.lazyPut(() => UpdateJobStatusUseCase(Get.find()));
    Get.lazyPut(() => GetJobChatMembersUseCase(Get.find()));
    Get.lazyPut(() => EmitJobUpdateUseCase(Get.find()));
    Get.lazyPut(() => ListenChatEventsUseCase(Get.find()));
    Get.lazyPut(() => DeleteMessagesUseCase(Get.find()));

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
        emitJobUpdateUseCase: Get.find(),
        uploadFileUseCase: Get.find(),
        listenChatEventsUseCase: Get.find(),
      ),
    );
  }
}
