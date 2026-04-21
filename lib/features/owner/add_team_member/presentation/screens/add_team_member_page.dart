import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/border/app_dashed_border.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/add_member_bottom_sheet.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/widgets/member_list_tile.dart';

class AddTeamMemberPage extends GetView<AddTeamMemberController> {
  const AddTeamMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.addTeamMember.appBarTitle,
      actions: [
        AppButton.ghost(
          text: AppStrings.addTeamMember.skipButton,
          onPressed: controller.completeOnboarding,
          width: null,
          height: null,
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

          // Add Member Entry Tile
          AppDashedBorder(
            color: context.theme.colorScheme.primary.withValues(alpha: 0.5),
            borderRadius: AppUIConstants.radius.radius$12,
            dashWidth: 6,
            dashSpace: 4,
            child: ListTile(
              onTap: () => _showAddMemberBottomSheet(context),
              leading: Container(
                padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              title: Text(
                AppStrings.addTeamMember.addNewMemberTile,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.primary,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppUIConstants.radius.radius$12,
                ),
              ),
            ),
          ),

          // Member List
          Obx(() {
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

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.members.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 72,
                color: context.theme.colorScheme.outlineVariant,
              ),
              itemBuilder: (context, index) {
                final member = controller.members[index];
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 400 + (index * 50)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: MemberListTile(member: member),
                );
              },

            );
          }),
        ],
      ),
    );
  }

  void _showAddMemberBottomSheet(BuildContext context) {
    controller.resetForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMemberBottomSheet(controller: controller),
    );
  }
}
