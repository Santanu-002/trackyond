import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/repositories/job_chat_repository_impl.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_chat_members_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/get_job_messages_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/send_message_usecase.dart';
import 'package:trackyond/features/job_chat/domain/usecases/update_job_status_usecase.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/worker/attendance/data/data_sources/attendance_remote_data_source.dart';
import 'package:trackyond/features/worker/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:trackyond/features/worker/attendance/domain/repositories/attendance_repository.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/get_attendance_status_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/start_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';

class JobChatBinding extends Bindings {
  @override
  void dependencies() {
    // ── Job Chat data layer ────────────────────────────────────────────
    Get.lazyPut<IJobChatDataSource>(() => JobChatRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<IJobChatRepository>(() => JobChatRepositoryImpl(Get.find()));

    // ── Job Chat use cases ─────────────────────────────────────────────
    Get.lazyPut(() => GetJobMessagesUseCase(Get.find()));
    Get.lazyPut(() => SendMessageUseCase(Get.find()));
    Get.lazyPut(() => UpdateJobStatusUseCase(Get.find()));
    Get.lazyPut(() => GetJobChatMembersUseCase(Get.find()));

    // ── Attendance dependencies (needed for worker attendance check) ───
    if (!Get.isRegistered<AttendanceController>()) {
      if (!Get.isRegistered<IAttendanceRemoteDataSource>()) {
        Get.lazyPut<IAttendanceRemoteDataSource>(
          () => AttendanceRemoteDataSourceImpl(Get.find<Dio>()),
        );
      }
      if (!Get.isRegistered<IAttendanceRepository>()) {
        Get.lazyPut<IAttendanceRepository>(
          () => AttendanceRepositoryImpl(Get.find<IAttendanceRemoteDataSource>()),
        );
      }
      if (!Get.isRegistered<StartAttendanceUseCase>()) {
        Get.lazyPut(() => StartAttendanceUseCase(Get.find<IAttendanceRepository>()));
      }
      if (!Get.isRegistered<EndAttendanceUseCase>()) {
        Get.lazyPut(() => EndAttendanceUseCase(Get.find<IAttendanceRepository>()));
      }
      if (!Get.isRegistered<GetAttendanceStatusUseCase>()) {
        Get.lazyPut(() => GetAttendanceStatusUseCase(Get.find<IAttendanceRepository>()));
      }
      Get.put(
        AttendanceController(
          startAttendanceUseCase: Get.find(),
          endAttendanceUseCase: Get.find(),
          getAttendanceStatusUseCase: Get.find(),
        ),
        permanent: true,
      );
    }

    // ── Controller ─────────────────────────────────────────────────────
    Get.lazyPut(
      () => JobChatController(
        getMessagesUseCase: Get.find(),
        sendMessageUseCase: Get.find(),
        getChatMembersUseCase: Get.find(),
      ),
    );
  }
}
