import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/events/chat_event.dart';

class ListenChatEventsUseCase implements BaseUseCase<Stream<ChatEvent>, NoParams> {
  final IEventBusRepository _eventBus;

  ListenChatEventsUseCase(this._eventBus);

  @override
  Future<Either<AppFailure, Stream<ChatEvent>>> call(NoParams params) async {
    return right(_eventBus.on<ChatEvent>());
  }
}
