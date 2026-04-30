import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/common/widgets/chip/app_tag.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member_call_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:flutter/services.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance_info_tile.dart';
import 'package:trackyond/app/routes/app_routes.dart';


class TeamMemberProfilePage extends GetView<TeamMemberProfileController> {
  const TeamMemberProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final member = controller.member;

    return AppScaffold(
      title: member.name,
      padding: EdgeInsets.zero,
      actions: [
        ...[
        MemberCallButton(phoneNumber: member.phone),
        AppUIConstants.widgets.horizontalBox$16,
      ],
        _buildExportMenu(context),
        AppUIConstants.widgets.horizontalBox$16,
      ],
      child: Column(
        children: [
          _buildHeader(context),
          AppSection(
            title: AppStrings.teamMemberProfile.attendanceLogs,
            padding: EdgeInsets.symmetric(
              vertical: AppUIConstants.spacing.space$24,
            ),
            child: _buildAttendanceSection(context),
          ),
          AppSection(
            title: AppStrings.teamMemberProfile.manageMember,
            padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$32),
            child: _buildActionsSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final member = controller.member;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppUIConstants.radius.radius$32),
          bottomRight: Radius.circular(AppUIConstants.radius.radius$32),
        ),
      ),
      child: Column(
        children: [
          Hero(
            tag: 'avatar_${member.accountUid}',
            child: MemberAvatar(
              name: member.name,
              image: member.image,
              radius: 64,
            ),
          ),
          AppUIConstants.widgets.verticalBox$16,
          Hero(
            tag: 'name_${member.accountUid}',
            child: Material(
              color: Colors.transparent,
              child: Text(
                member.name,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (member.designation != null && member.designation!.isNotEmpty) ...[
            AppUIConstants.widgets.verticalBox$12,
            AppTag(
              label: member.designation!,
              icon: Icons.work_outline,
            ),
          ],
          if (member.phone.isNotEmpty) ...[
            AppUIConstants.widgets.verticalBox$8,
            GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: member.phone));
                Get.snackbar(
                  'Copied',
                  'Phone number copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
                  colorText: context.theme.colorScheme.onSurface,
                  margin: EdgeInsets.all(AppUIConstants.spacing.space$16),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                  AppUIConstants.widgets.horizontalBox$8,
                  Text(
                    member.phone,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
          AppUIConstants.widgets.verticalBox$24,
          _buildTodayStatusCard(context),
        ],
      ),
    );
  }

  Widget _buildTodayStatusCard(BuildContext context) {
    final member = controller.member;
    return AppCard(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.teamMemberProfile.todayStatus,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppUIConstants.widgets.verticalBox$4,
                AppStatusChip.attendance(
                  attendanceStatus: member.status,
                  context: context,
                ),
              ],
            ),
          ),
          if (member.startAt != null) ...[
            Container(
              width: 1,
              height: 40,
              color: context.theme.colorScheme.outlineVariant,
              margin: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppStrings.teamMemberProfile.activeSince,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppUIConstants.widgets.verticalBox$4,
                Text(
                  DateFormat('hh:mm a').format(member.startAt!.toLocal()),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.teamMemberProfile.attendanceLogs,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        AppUIConstants.widgets.verticalBox$16,
        Obx(() => AppButton.outlined(
          onPressed: () => controller.selectDateRange(context),
          text: '${DateFormat('dd MMM').format(controller.dateRange.value.start)} - ${DateFormat('dd MMM').format(controller.dateRange.value.end)}',
          leading: const Icon(Icons.date_range),
        )),
        AppUIConstants.widgets.verticalBox$16,
        Obx(() {
          if (controller.isLoadingLogs.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.logs.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppUIConstants.spacing.space$32),
                child: Text(AppStrings.teamMemberProfile.noLogsFound, style: context.textTheme.bodyMedium),
              ),
            );
          }
          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.logs.length > 10 ? 10 : controller.logs.length,
                separatorBuilder: (_, _) => AppUIConstants.widgets.verticalBox$12,
                itemBuilder: (context, index) {
                  final log = controller.logs[index];
                  
                  return AppCard(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('EEEE, dd MMM yyyy').format(log.date),
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppStatusChip.attendance(
                              attendanceStatus: AttendanceStatus.fromString(log.status),
                              context: context,
                            ),
                          ],
                        ),
                        AppUIConstants.widgets.verticalBox$16,
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: AppUIConstants.spacing.space$12,
                          mainAxisSpacing: AppUIConstants.spacing.space$12,
                          childAspectRatio: 3,
                          children: [
                            AttendanceInfoTile(
                              icon: Icons.location_on_outlined,
                              text: log.location ?? '-',
                              color: context.theme.colorScheme.primary,
                            ),
                            AttendanceInfoTile(
                              icon: Icons.access_time_outlined,
                              text: DateFormat('hh:mm a').format(log.checkIn),
                              color: context.theme.colorScheme.pending,
                            ),
                            AttendanceInfoTile(
                              icon: Icons.timer_outlined,
                              text: log.workHours,
                              color: context.theme.colorScheme.error,
                            ),
                            AttendanceInfoTile(
                              icon: Icons.calendar_today_outlined,
                              text: DateFormat('dd MMM yyyy').format(log.date),
                              color: context.theme.colorScheme.completed,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              AppUIConstants.widgets.verticalBox$16,
              AppButton.outlined(
                onPressed: () => Get.toNamed(AppRoutes.owner.teamMemberAttendance, arguments: controller.member),
                text: AppStrings.teamMemberProfile.viewAllLogs,
                width: double.infinity,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildExportMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.download_outlined),
      tooltip: AppStrings.teamMemberProfile.exportLogs,
      onSelected: (value) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        final Rect? rect = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
        switch (value) {
          case 'pdf':
            controller.exportToPdf(sharePositionOrigin: rect);
            break;
          case 'csv':
            controller.exportToCsv(sharePositionOrigin: rect);
            break;
          case 'txt':
            controller.exportToTxt(sharePositionOrigin: rect);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text('Export as PDF'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'csv',
          child: Row(
            children: [
              Icon(Icons.table_chart, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Text('Export as CSV'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'txt',
          child: Row(
            children: [
              Icon(Icons.description, color: Colors.blue, size: 20),
              SizedBox(width: 12),
              Text('Export as TXT'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.teamMemberProfile.manageMember,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppUIConstants.widgets.verticalBox$16,
        AppButton.filled(
          onPressed: () => _showEditDialog(context),
          text: AppStrings.teamMemberProfile.editProfile,
          leading: const Icon(Icons.edit_outlined),
        ),
        AppUIConstants.widgets.verticalBox$12,
        AppButton.outlined(
          onPressed: () => controller.markAsExEmployee(),
          text: AppStrings.teamMemberProfile.markAsExEmployee,
          leading: const Icon(Icons.person_remove_outlined),
          color: Colors.red,
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final designationController = TextEditingController(text: controller.member.designation);
    final phoneController = TextEditingController(text: controller.member.phone);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
        ),
        title: Text(AppStrings.teamMemberProfile.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: designationController,
              label: AppStrings.teamMemberProfile.designationLabel,
              prefixIcon: Icons.work_outline,
            ),
            AppUIConstants.widgets.verticalBox$16,
            AppTextField(
              controller: phoneController,
              label: AppStrings.teamMemberProfile.phoneLabel,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.teamMemberProfile.cancel),
          ),
          Obx(() => AppButton.filled(
                onPressed: () => controller.editProfile(
                  designationController.text,
                  phoneController.text,
                ),
                text: AppStrings.teamMemberProfile.save,
                isLoading: controller.isUpdatingProfile.value,
              )),
        ],
      ),
    );
  }
}
