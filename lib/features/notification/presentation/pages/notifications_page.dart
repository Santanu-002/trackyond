import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends GetView<NotificationController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.notifications.appBarTitle,
      automaticallyImplyLeading: true,
      useScrollView: false,
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () {
            controller.notifications.clear();
            controller.clearUnread();
          },
          tooltip: AppStrings.notifications.clearAll,
        )
      ],
      child: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(AppStrings.notifications.noNotifications),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.notifications),
              ),
              title: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification.body),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, y h:mm a').format(notification.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                if (notification.data != null) {
                  // For now we just print, but can route here in future
                  debugPrint('Notification list tapped: ${notification.data}');
                  if (notification.data!['type'] == 'jobAssigned') {
                    // Get.toNamed(AppRoutes.owner.jobDetails, arguments: notification.data!['jobId']);
                  }
                }
              },
            );
          },
        );
      }),
    );
  }
}
