import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';

abstract class INotificationDataSource {
  Future<Either<AppFailure, void>> syncFcmToken({
    required UserRole role,
    required String fcmToken,
  });
}

class NotificationDataSourceImpl implements INotificationDataSource {
  final Dio _dio;
  final DeviceIdService _deviceService;

  NotificationDataSourceImpl(this._dio, this._deviceService);

  @override
  Future<Either<AppFailure, void>> syncFcmToken({
    required UserRole role,
    required String fcmToken,
  }) async {
    try {
      final endpoint = role == UserRole.owner
          ? '/admin/fcm-token'
          : '/employee/fcm-token';

      final deviceId = await _deviceService.getDeviceId();
      final platform = Platform.operatingSystem;
      // We could use PackageInfo here if needed, keeping simple for now
      const appVersion = "1.0.0"; 

      await _dio.post(
        endpoint,
        data: {
          'device_id': deviceId,
          'fcm_token': fcmToken,
          'platform': platform,
          'app_version': appVersion,
        },
      );
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
