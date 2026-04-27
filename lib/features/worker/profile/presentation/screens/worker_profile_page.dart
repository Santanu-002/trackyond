import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/layout/app_nav_layout.dart';
import 'package:trackyond/features/worker/profile/presentation/controllers/worker_profile_controller.dart';

class WorkerProfilePage extends GetView<WorkerProfileController> {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppNavLayout(
      title: AppStrings.workerProfile.title,
      child: Center(
        child: Text('Profile Page Placeholder'),
      ),
    );
  }
}
