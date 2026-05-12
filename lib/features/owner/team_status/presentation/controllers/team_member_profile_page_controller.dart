import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/presentation/entities/profile/team_member_profile_action.dart';


class TeamMemberProfilePageController extends GetxController {
  final memberStatus = Rxn<TeamMemberStatusEntity>();

  List<TeamMemberProfileAction> get actions => [
    TeamMemberProfileAction(
      icon: AppIcons.auth.phoneOutlined,
      label: AppStrings.teamMemberProfile.call,
      onTap: onCall,
    ),
    TeamMemberProfileAction(
      icon: AppIcons.common.chat,
      label: AppStrings.teamMemberProfile.message,
      onTap: onMessage,
    ),
    TeamMemberProfileAction(
      icon: AppIcons.common.history,
      label: AppStrings.teamMemberProfile.logs,
      onTap: onLogs,
    ),
    TeamMemberProfileAction(
      icon: AppIcons.common.edit,
      label: AppStrings.common.edit,
      onTap: onEdit,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is TeamMemberStatusEntity) {
      memberStatus.value = Get.arguments as TeamMemberStatusEntity;
    }
  }

  void onCopyPhone() {
    final phone = memberStatus.value?.profile.phone;
    if (phone != null) {
      AppUtils.copyToClipboard(phone);
    }
  }

  Future<void> onCall() async {
    final phone = memberStatus.value?.profile.phone;
    if (phone != null) {
      final Uri launchUri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    }
  }

  Future<void> onMessage() async {
    final phone = memberStatus.value?.profile.phone;
    if (phone != null) {
      final Uri launchUri = Uri(scheme: 'sms', path: phone);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    }
  }

  void onLogs() {
    // TODO: Implement logs view
  }

  void onEdit() {
    // TODO: Implement edit profile
  }
}

