import 'package:get/get.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';

class TeamMemberProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeamMemberProfilePageController());
  }
}
