import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_attendance_controller.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance_info_tile.dart';

class TeamMemberAttendancePage extends GetView<TeamMemberAttendanceController> {
  const TeamMemberAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Attendance Logs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => controller.selectDateRange(context),
          ),
          Obx(() => controller.isLoadingExport.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: controller.exportLogs,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'pdf',
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(AppStrings.teamMemberProfile.exportAsPdf),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'csv',
                      child: Row(
                        children: [
                          const Icon(Icons.table_chart_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(AppStrings.teamMemberProfile.exportAsCsv),
                        ],
                      ),
                    ),
                  ],
                )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
            child: AppSearchBar<String>(
              query: controller.searchQuery,
              hintText: AppStrings.teamMemberAttendance.searchHint,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingLogs.value && controller.logs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.logs.isEmpty) {
                return Center(
                  child: Text(
                    'No attendance logs found.',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              final groupedLogs = controller.groupedLogs;
              final keys = groupedLogs.keys.toList();

              return CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  ...keys.map((key) {
                    final logs = groupedLogs[key]!;
                    
                    // Format key "2026-04" to "April 2026"
                    final parts = key.split('-');
                    final month = int.parse(parts[1]);
                    final year = int.parse(parts[0]);
                    final date = DateTime(year, month);
                    final headerText = DateFormat('MMMM yyyy').format(date);

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyHeaderDelegate(
                              text: headerText,
                              backgroundColor: context.theme.colorScheme.surface,
                              textColor: context.theme.colorScheme.onSurface,
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(
                              bottom: AppUIConstants.spacing.space$24,
                              top: AppUIConstants.spacing.space$8,
                            ),
                            sliver: SliverList.separated(
                              itemCount: logs.length,
                              separatorBuilder: (_, _) => AppUIConstants.widgets.verticalBox$12,
                              itemBuilder: (context, logIndex) {
                                final log = logs[logIndex];
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
                          ),
                        ],
                      ),
                    );
                  }),
                  if (controller.isLoadingMore.value)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppUIConstants.spacing.space$16),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  // Bottom padding for scroll area
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppUIConstants.spacing.space$32),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  _StickyHeaderDelegate({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: AppUIConstants.spacing.space$4),
      child: Text(
        text,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return text != oldDelegate.text ||
        backgroundColor != oldDelegate.backgroundColor ||
        textColor != oldDelegate.textColor;
  }
}
