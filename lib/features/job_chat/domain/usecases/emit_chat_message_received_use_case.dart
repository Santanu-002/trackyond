import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/events/chat_event.dart';

class EmitChatMessageReceivedUseCase implements BaseUseCase<Unit, JobChatMessageEntity> {
  final IEventBusRepository _eventBus;

  EmitChatMessageReceivedUseCase(this._eventBus);

  @override
  Future<Either<AppFailure, Unit>> call(JobChatMessageEntity params) async {
    _eventBus.fire(ChatMessageReceivedEvent(params));
    return right(unit);
  }
}
