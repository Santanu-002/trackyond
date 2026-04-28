import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:trackyond/features/attendance/data/data_sources/attendance_remote_data_source.dart';
import 'package:trackyond/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:trackyond/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:trackyond/features/attendance/domain/usecases/start_attendance_usecase.dart';
import 'package:trackyond/features/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/attendance/domain/usecases/get_attendance_status_usecase.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    // Data layer
    Get.lazyPut<IAttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSourceImpl(Get.find<Dio>()),
    );
    Get.lazyPut<IAttendanceRepository>(
      () => AttendanceRepositoryImpl(Get.find<IAttendanceRemoteDataSource>()),
    );

    // Use cases
    Get.lazyPut(() => StartAttendanceUseCase(Get.find<IAttendanceRepository>()));
    Get.lazyPut(() => EndAttendanceUseCase(Get.find<IAttendanceRepository>()));
    Get.lazyPut(() => GetAttendanceStatusUseCase(Get.find<IAttendanceRepository>()));
  }
}
