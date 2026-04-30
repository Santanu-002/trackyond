import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/drawer/app_drawer_header.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/drawer/drawer_item.dart';

class AppDrawer extends GetView<OwnerDashboardController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.drawer;
    final theme = context.theme;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Obx(
            () => AppDrawerHeader(
              name: controller.ownerName.value,
              phone: controller.ownerPhone.value,
            ),
          ),

          Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            thickness: 1,
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.drawerItems.length,
              itemBuilder: (context, index) {
                final item = controller.drawerItems[index];
                return DrawerItem(
                  icon: item.icon,
                  label: item.label,
                  isActive: index == 0, // Mocked: Dashboard is active
                  onTap: () {
                    // Navigate if route is present
                    if (item.route.isNotEmpty) {
                      Get.back(); // Close drawer
                      if (Get.currentRoute != item.route) {
                        Get.toNamed(item.route);
                      }
                    }
                  },
                );
              },
            ),
          ),

          // Footer / Logout
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppUIConstants.spacing.space$12,
              vertical: AppUIConstants.spacing.space$24,
            ),
            child: AppButton.filled(
              borderRadius: AppUIConstants.radius.radius$12,
              splashColor: theme.colorScheme.error.withValues(alpha: 0.1),
              gradientColors: [
                theme.colorScheme.error.withValues(alpha: 0.1),
                theme.colorScheme.error.withValues(alpha: 0.1),
              ],
              onPressed: () {
                Get.back();
                controller.logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppUIConstants.spacing.space$8,
                children: [
                  Icon(
                    AppIcons.common.logout,
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  Text(
                    strings.logout,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
