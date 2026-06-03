import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';

class MockJobChatRepositoryImpl implements IJobChatRepository {
  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(
    String jobId, {
    MessageQueryOptions? options,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right([
      JobChatMessageEntity(
        uid: '1',
        localId: null,
        jobId: jobId,
        senderUid: 'system',
        type: JobChatMessageType.activity,
        content: const [
          JobChatMessageContentEntity(
            type: JobChatMessageContentType.text,
            content: 'Job fixing server connection has been reopened.',
          ),
        ],
        createdByAuthorAt: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
      JobChatMessageEntity(
        uid: '2',
        localId: null,
        jobId: jobId,
        senderUid: 'worker',
        type: JobChatMessageType.message,
        content: const [
          JobChatMessageContentEntity(
            type: JobChatMessageContentType.text,
            content: 'Hello, I am on my way.',
          ),
        ],
        createdByAuthorAt: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
    ]);
  }

  @override
  Future<Either<AppFailure, SendMessageResult>> sendMessage(List<SendMessageEntity> messages) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (messages.isEmpty) {
      return Left(ServerFailure('No messages to send'));
    }
    final msg = messages.last;
    final mockMessage = JobChatMessageEntity(
      uid: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      localId: msg.localId,
      jobId: msg.jobId,
      senderUid: msg.senderUid,
      content: msg.content,
      type: msg.type,
      metadata: msg.metadata,
      actionPerformed: msg.actionPerformed,
      createdByAuthorAt: msg.createdByAuthorAt,
      createdAt: DateTime.now(),
      isMe: true,
    );
    return Right(SendMessageResult(
      message: mockMessage,
      messages: [mockMessage],
      allowedActions: const [],
      job: null,
    ));
  }

  @override
  Future<Either<AppFailure, JobEntity>> updateJobStatus(String jobId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(JobEntity(
      jobId: jobId,
      jobTitle: 'Mock Job',
      customerName: 'Customer',
      customerPhone: '1234567890',
      workerProfileUid: 'worker',
      status: JobStatus.fromString(status),
      requirePhotoOnStart: false,
      requirePhotoOnComplete: false,
      captureLocation: false,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Either<AppFailure, List<MemberProfile>>> getChatMembers(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const Right([]);
  }

  @override
  Future<Either<AppFailure, void>> deleteMessages({
    required String jobId,
    required String deleteType,
    required List<String> messageUids,
    required DateTime deletedByUserAt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Right(null);
  }
}
