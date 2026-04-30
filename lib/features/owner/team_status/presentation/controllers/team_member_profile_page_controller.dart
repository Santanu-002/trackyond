import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';

class TeamMemberProfilePageController extends GetxController {
  final member = Rxn<MemberProfile>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is MemberProfile) {
      member.value = Get.arguments as MemberProfile;
    }
  }
}
