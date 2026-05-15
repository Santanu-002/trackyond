import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class GetNotificationsUseCase implements BaseUseCase<List<NotificationEntity>, NotificationFilterOptions> {
  final INotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<NotificationEntity>>> call(NotificationFilterOptions params) async {
    return _repository.getNotifications(options: params);
  }
}

