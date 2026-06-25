import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/events/job_event.dart';

class EmitJobUpdateUseCase implements BaseUseCase<Unit, JobEntity> {
  final IEventBusRepository _eventBus;

  EmitJobUpdateUseCase(this._eventBus);

  @override
  Future<Either<AppFailure, Unit>> call(JobEntity params) async {
    _eventBus.fire(JobUpdatedEvent(params));
    return right(unit);
  }
}
