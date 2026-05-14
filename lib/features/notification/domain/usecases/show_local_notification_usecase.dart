import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class ShowLocalNotificationUseCase implements BaseUseCase<void, ShowLocalNotificationParams> {
  final INotificationRepository _repository;

  ShowLocalNotificationUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(ShowLocalNotificationParams params) {
    return _repository.showLocalNotification(
      title: params.title,
      body: params.body,
      payload: params.payload,
    );
  }
}

class ShowLocalNotificationParams {
  final String title;
  final String body;
  final Map<String, dynamic>? payload;

  ShowLocalNotificationParams({
    required this.title,
    required this.body,
    this.payload,
  });
}
