import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void custom({
    required String message,
    required Color backgroundColor,
    IconData? icon,
    SnackBarAction? action,
  }) {
    final context = Get.context;
    if (context == null) return;

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: context.theme.colorScheme.onPrimary,
              size: 24.0,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: context.theme.colorScheme.onPrimary,
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
      backgroundColor: Get.theme.colorScheme.tertiary,
      action: action,
    );
  }

  static void destructive(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: Get.theme.colorScheme.error,
      action: action,
    );
  }

  static void warn(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: Get.theme.colorScheme.pending,
      action: action,
    );
  }

  static void info(String message, {SnackBarAction? action}) {
    custom(
      message: message,
      backgroundColor: Get.theme.colorScheme.primary,
      action: action,
    );
  }
}
