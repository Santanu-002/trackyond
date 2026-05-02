import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/profile/profile_action_button.dart';

class MemberProfileActions extends GetView<TeamMemberProfilePageController> {
  const MemberProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(controller.actions.length, (index) {
        final action = controller.actions[index];
        return ProfileActionButton(
          icon: action.icon,
          label: action.label,
          onTap: action.onTap,
        );
      }),
    );
  }
}
