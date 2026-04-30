import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';

class TeamMemberProfilePage extends GetView<TeamMemberProfilePageController> {
  const TeamMemberProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: Obx(() {
        final member = controller.member.value;
        if (member == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context, member),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(context, member),
                  // _buildAttendanceCard(context, member), // Removed since member is now MemberProfile
                  _buildActionGrid(context),
                  const Divider(height: 1),
                  _buildSettingsSection(context),
                  const SizedBox(height: 800),
                  AppUIConstants.widgets.verticalBox$32,
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, member) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: context.theme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: CircleAvatar(
          backgroundColor: Colors.black26,
          child: Icon(AppIcons.common.back, color: Colors.white, size: 18),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final double percentage =
                (constraints.maxHeight - kToolbarHeight) /
                (300 - kToolbarHeight);
            return Opacity(
              opacity: 1.0 - percentage.clamp(0.0, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (member.designation != null)
                    Text(
                      member.designation!,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        background: Center(
          child: Hero(
            tag: 'avatar_${member.accountUid}',
            child: MemberAvatar(
              name: member.name,
              image: member.image,
              radius: AppUIConstants.radius.radius$56,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context, member) {
    return Padding(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            member.name,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppUIConstants.widgets.verticalBox$4,
          Text(
            '${member.designation ?? ""} • ${member.phone}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, member) {
    final attendance = member.todayAttendance;
    final hasStarted = attendance != null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
      padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        border: Border.all(
          color: context.theme.colorScheme.outlineVariant.withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.teamMemberProfile.todayAttendance,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppStatusChip.attendance(
                attendanceStatus: member.status,
                context: context,
              ),
            ],
          ),
          AppUIConstants.widgets.verticalBox$16,
          if (hasStarted) ...[
            _buildAttendanceDetailRow(
              context,
              AppIcons.dashboard.clock,
              AppStrings.teamMemberProfile.clockIn,
              DateFormat('hh:mm a').format(attendance.startAt.toLocal()),
            ),
            AppUIConstants.widgets.verticalBox$16,
            if (attendance.endAt != null) ...[
              _buildAttendanceDetailRow(
                context,
                AppIcons.dashboard.clock,
                AppStrings.teamMemberProfile.clockOut,
                DateFormat('hh:mm a').format(attendance.endAt!.toLocal()),
              ),
              AppUIConstants.widgets.verticalBox$16,
            ],
            if (attendance.workHours != null) ...[
              _buildAttendanceDetailRow(
                context,
                AppIcons.dashboard.timer,
                AppStrings.teamMemberProfile.workHours,
                '${attendance.workHours!.toStringAsFixed(1)} hrs',
              ),
              AppUIConstants.widgets.verticalBox$16,
            ],
            if (attendance.startAddress != null)
              _buildAttendanceDetailRow(
                context,
                AppIcons.dashboard.location,
                AppStrings.teamMemberProfile.location,
                attendance.startAddress!,
                isMultiline: true,
              ),
          ] else
            Text(
              AppStrings.teamMemberProfile.noAttendanceRecord,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: context.theme.colorScheme.primary),
        AppUIConstants.widgets.horizontalBox$12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: isMultiline ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppUIConstants.spacing.space$24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            AppIcons.auth.phoneOutlined,
            AppStrings.teamMemberProfile.call,
          ),
          _buildActionButton(
            context,
            Icons.chat_bubble_outline,
            AppStrings.teamMemberProfile.message,
          ),
          _buildActionButton(
            context,
            Icons.history_rounded,
            AppStrings.teamMemberProfile.logs,
          ),
          _buildActionButton(
            context,
            Icons.edit_outlined,
            AppStrings.teamMemberProfile.edit,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer.withValues(
              alpha: 0.3,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: context.theme.colorScheme.primary, size: 24),
        ),
        AppUIConstants.widgets.verticalBox$8,
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          context,
          Icons.notifications_none_rounded,
          AppStrings.teamMemberProfile.customNotifications,
        ),
        _buildListTile(
          context,
          Icons.security_outlined,
          AppStrings.teamMemberProfile.accessPermissions,
        ),
        _buildListTile(
          context,
          Icons.block_flipped,
          AppStrings.teamMemberProfile.deactivateMember,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? context.theme.colorScheme.error
        : context.theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(color: color),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    );
  }
}
