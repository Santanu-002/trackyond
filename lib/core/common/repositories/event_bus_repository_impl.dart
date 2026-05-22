import 'dart:async';
import 'package:trackyond/core/common/events/app_event.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';

class EventBusRepositoryImpl implements IEventBusRepository {
  final _controller = StreamController<AppEvent>.broadcast();

  @override
  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  @override
  void fire(AppEvent event) {
    _controller.add(event);
  }
}
