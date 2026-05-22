import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/events/job_event.dart';

class ListenJobEventsUseCase implements BaseUseCase<Stream<JobEvent>, NoParams> {
  final IEventBusRepository _eventBus;

  ListenJobEventsUseCase(this._eventBus);

  @override
  Future<Either<AppFailure, Stream<JobEvent>>> call(NoParams params) async {
    return right(_eventBus.on<JobEvent>());
  }
}
