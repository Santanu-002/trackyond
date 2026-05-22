import 'package:trackyond/core/common/events/app_event.dart';

abstract interface class IEventBusRepository {
  Stream<T> on<T extends AppEvent>();
  void fire(AppEvent event);
}
