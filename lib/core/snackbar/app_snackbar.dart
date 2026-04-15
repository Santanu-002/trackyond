import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/theme/app_colors.dart';

class AppSnackbar {
  static void success(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.light.completed,
      snackStyle: SnackStyle.FLOATING,
      icon: HugeIcon(
        icon: AppIcons.status.success,
        color: Colors.white,
        size: 24.0,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  static void error(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.light.error,
      snackStyle: SnackStyle.FLOATING,
      icon: HugeIcon(
        icon: AppIcons.status.error,
        color: Colors.white,
        size: 24.0,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
    );
  }

  static void info(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.light.brandBlue,
      snackStyle: SnackStyle.FLOATING,
      icon: HugeIcon(
        icon: AppIcons.status.info,
        color: Colors.white,
        size: 24.0,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
