import 'package:get/get.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/edit_member_profile_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_member_attendance_logs_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/mark_ex_employee_usecase.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_controller.dart';

class TeamMemberProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetMemberAttendanceLogsUseCase(Get.find<ITeamRepository>()));
    Get.lazyPut(() => EditMemberProfileUseCase(Get.find<ITeamRepository>()));
    Get.lazyPut(() => MarkExEmployeeUseCase(Get.find<ITeamRepository>()));

    Get.lazyPut(() => TeamMemberProfileController(
      Get.find<GetMemberAttendanceLogsUseCase>(),
      Get.find<EditMemberProfileUseCase>(),
      Get.find<MarkExEmployeeUseCase>(),
    ));
  }
}
