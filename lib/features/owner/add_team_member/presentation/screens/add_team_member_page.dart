import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/add_member_tile.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/member_list_tile.dart';

class AddTeamMemberPage extends GetView<AddTeamMemberController> {
  const AddTeamMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: false,
      title: AppStrings.addTeamMember.appBarTitle,
      actions: [
        Padding(
          padding: EdgeInsetsGeometry.only(
            right: AppUIConstants.spacing.space$24,
          ),

          child: Obx(
            () => AppButton.ghost(
              text: controller.hasAddedNewMember
                  ? AppStrings.addTeamMember.doneButton
                  : AppStrings.addTeamMember.skipButton,
              onPressed: controller.completeOnboarding,
              width: null,
              height: null,
            ),
          ),
        ),
      ],

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUIConstants.spacing.space$24,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.spacing.space$8,
            children: [
              Text(
                AppStrings.addTeamMember.title,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              Text(
                AppStrings.addTeamMember.subtitle,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          // Add Member Entry Button (Centered with Dotted Border)
          AddMemberTile(onTap: controller.navigateToAddMemberDetails),

          // Member List
          Expanded(
            child: Obx(() {
              if (controller.isFetching.value && controller.members.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.members.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.addTeamMember.noMembersYet,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.members.length,
                itemBuilder: (context, index) {
                  final member = controller.members[index];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (index * 50)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            AppUIConstants.spacing.space$20 * (1 - value),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: MemberListTile(member: member),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
