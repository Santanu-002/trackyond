import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class GetJobChatMembersUseCase implements BaseUseCase<List<MemberProfile>, String> {
  final IJobChatRepository _repository;

  GetJobChatMembersUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<MemberProfile>>> call(String jobId) {
    return _repository.getChatMembers(jobId);
  }
}
