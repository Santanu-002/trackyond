import 'package:fpdart/fpdart.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';
import 'package:trackyond/features/notification/data/datasources/notification_data_source.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/notification/fcm_token_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final FCMTokenService _fcmTokenService;
  final INotificationDataSource _dataSource;
  final UserService _userService;

  NotificationRepositoryImpl(
    this._fcmTokenService,
    this._dataSource,
    this._userService,
  );

  @override
  Future<Either<AppFailure, void>> syncFcmToken() async {
    try {
      final currentToken = await _fcmTokenService.getCurrentToken();
      if (currentToken == null) {
        return const Right(null);
      }

      final lastToken = _fcmTokenService.getLastToken();
      final isSynced = _fcmTokenService.getIsSynced();

      if (currentToken != lastToken || !isSynced) {
        final currentUser = _userService.getUser();
        if (currentUser == null) {
          return const Right(null); // Wait for login to sync
        }

        final result = await _dataSource.syncFcmToken(
          role: currentUser.role,
          fcmToken: currentToken,
        );

        return result.fold(
          (failure) async {
            await _fcmTokenService.markTokenAsUnsynced();
            return Left(failure);
          },
          (_) async {
            await _fcmTokenService.markTokenAsSynced(currentToken);
            return const Right(null);
          },
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteFcmToken() async {
    try {
      await _fcmTokenService.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
