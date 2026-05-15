import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments ?? {};

    return AppScaffold(
      title: AppStrings.notifications.notificationDetails,
      child: Padding(
        padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.isEmpty)
              Center(child: Text(AppStrings.notifications.noDetailsAvailable))
            else
              ...data.entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: AppUIConstants.spacing.space$12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      AppUIConstants.widgets.verticalBox$4,
                      Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontSize: AppUIConstants.spacing.space$16,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
