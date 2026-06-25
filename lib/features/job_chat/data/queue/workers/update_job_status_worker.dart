import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';

class UpdateJobStatusWorker implements QueueWorker {
  final IJobChatRemoteDataSource _remoteDataSource;

  UpdateJobStatusWorker({
    required IJobChatRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  QueueTaskType get type => QueueTaskType.updateJobStatus;

  @override
  Future<WorkResult> execute(QueueTask task) async {
    final payload = task.payload as Map<String, dynamic>;
    final jobId = payload['jobId'] as String;
    final status = payload['status'] as String;

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (!isOnline) {
      return WorkResult.failure(task: task, message: 'Offline');
    }

    try {
      final response = await _remoteDataSource.updateJobStatus(
        jobId: jobId,
        status: status,
      );

      return response.fold(
        (failure) => WorkResult.failure(task: task, message: failure.message),
        (jobModel) => WorkResult.success(task: task, message: 'Job status updated', data: jobModel?.toJson()),
      );
    } catch (e) {
      return WorkResult.failure(task: task, message: e.toString());
    }
  }
}
