import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:trackyond/features/worker/attendance/data/data_sources/attendance_remote_data_source.dart';
import 'package:trackyond/features/worker/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:trackyond/features/worker/attendance/domain/repositories/i_attendance_repository.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/start_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/get_attendance_status_usecase.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';

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

    // Controllers
    Get.put(
      AttendanceController(
        startAttendanceUseCase: Get.find(),
        endAttendanceUseCase: Get.find(),
        getAttendanceStatusUseCase: Get.find(),
      ),
      permanent: true,
    );
  }
}
