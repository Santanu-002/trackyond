import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_summary_tab.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_status_tab.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_date_tab.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_worker_tab.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_vertical_tab.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final JobsController controller = Get.find<JobsController>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.7,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppUIConstants.radius.radius$24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          AppUIConstants.widgets.verticalBox$12,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AppUIConstants.widgets.verticalBox$16,

          // Content with Custom Vertical Tabs
          Expanded(
            child: Row(
              children: [
                // 1. Sidebar (Vertical Tabs - Label Only, Full Width Highlight)
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.surfaceContainerLow,
                    border: Border(
                      right: BorderSide(
                        color: context.theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      FilterVerticalTab(
                        label: 'Summary',
                        isSelected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      FilterVerticalTab(
                        label: 'Status',
                        isSelected: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                      FilterVerticalTab(
                        label: 'Date Range',
                        isSelected: _selectedIndex == 2,
                        onTap: () => setState(() => _selectedIndex = 2),
                      ),
                      FilterVerticalTab(
                        label: 'Assign To',
                        isSelected: _selectedIndex == 3,
                        onTap: () => setState(() => _selectedIndex = 3),
                      ),
                    ],
                  ),
                ),

                // 2. Tab Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
                    child: _buildTabContent(),
                  ),
                ),
              ],
            ),
          ),

          // Footer Actions
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    text: 'Reset All',
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                  ),
                ),
                AppUIConstants.widgets.horizontalBox$12,
                Expanded(
                  child: AppButton.filled(
                    text: 'Apply Filters',
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_selectedIndex) {
      0 => FilterSummaryTab(controller: controller),
      1 => FilterStatusTab(controller: controller),
      2 => FilterDateTab(controller: controller),
      3 => FilterWorkerTab(controller: controller),
      _ => const SizedBox.shrink(),
    };
  }
}
