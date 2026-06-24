import 'package:get/get.dart';
import 'package:trackyond/core/services/sync/sync_service.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_commands.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_command_handlers.dart';

class JobChatSyncInitializer {
  static void initialize() {
    SyncService.registerCommand<SendMessageCommand>(
      actionType: 'send_message',
      deserializer: SendMessageCommand.fromJson,
      handler: SendMessageCommandHandler(
        localDataSource: Get.find<IJobChatLocalDataSource>(),
        remoteDataSource: Get.find<IJobChatRemoteDataSource>(),
      ),
    );

    SyncService.registerCommand<DeleteMessagesCommand>(
      actionType: 'delete_messages',
      deserializer: DeleteMessagesCommand.fromJson,
      handler: DeleteMessagesCommandHandler(Get.find<IJobChatRemoteDataSource>()),
    );

    SyncService.registerCommand<SeenMessagesCommand>(
      actionType: 'seen_messages',
      deserializer: SeenMessagesCommand.fromJson,
      handler: SeenMessagesCommandHandler(Get.find<IJobChatRemoteDataSource>()),
    );

    SyncService.registerCommand<DeliveredMessagesCommand>(
      actionType: 'delivered_messages',
      deserializer: DeliveredMessagesCommand.fromJson,
      handler: DeliveredMessagesCommandHandler(Get.find<IJobChatRemoteDataSource>()),
    );

    SyncService.registerCommand<UpdateJobStatusCommand>(
      actionType: 'update_job_status',
      deserializer: UpdateJobStatusCommand.fromJson,
      handler: UpdateJobStatusCommandHandler(Get.find<IJobChatRemoteDataSource>()),
    );
  }
}
