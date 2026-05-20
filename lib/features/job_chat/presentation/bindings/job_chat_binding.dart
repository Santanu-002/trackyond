import 'package:get/get.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/update_job_status_usecase.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class JobChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IJobChatDataSource>(() => JobChatRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<IJobChatRepository>(() => JobChatRepositoryImpl(Get.find()));
    
    Get.lazyPut(() => GetJobMessagesUseCase(Get.find()));
    Get.lazyPut(() => SendMessageUseCase(Get.find()));
    Get.lazyPut(() => UpdateJobStatusUseCase(Get.find()));
    
    Get.lazyPut(
      () => JobChatController(
        getMessagesUseCase: Get.find(),
        sendMessageUseCase: Get.find(),
      ),
    );
  }
}
