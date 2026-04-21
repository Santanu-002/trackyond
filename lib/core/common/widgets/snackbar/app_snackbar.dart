import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:trackyond/core/theme/app_colors.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void custom({
    required String message,
    required Color backgroundColor,
    dynamic icon,
    SnackBarAction? action,
  }) {
    final context = Get.context;
    if (context == null) return;

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            HugeIcon(
              icon: icon,
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      elevation: 4,
      action: action,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void success(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: AppColors.light.completed,
      action: action,
    );
  }

  static void destructive(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: AppColors.light.error,
      action: action,
    );
  }

  static void warn(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: AppColors.light.pending,
      action: action,
    );
  }

  static void info(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: AppColors.light.brandBlue,
      action: action,
    );
  }
}
