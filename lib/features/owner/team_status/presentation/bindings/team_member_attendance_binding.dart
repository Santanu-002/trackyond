import 'package:get/get.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/export_member_attendance_logs_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_member_attendance_logs_usecase.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_attendance_controller.dart';

class TeamMemberAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetMemberAttendanceLogsUseCase(Get.find<ITeamRepository>()));
    Get.lazyPut(() => ExportMemberAttendanceLogsUseCase(Get.find<ITeamRepository>()));
    Get.lazyPut(() => TeamMemberAttendanceController(
      Get.find<GetMemberAttendanceLogsUseCase>(),
      Get.find<ExportMemberAttendanceLogsUseCase>(),
    ));
  }
}
