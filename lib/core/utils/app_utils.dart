import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';

class AppUtils {
  const AppUtils._();

  /// Formats a [DateTime] into a group header label for notifications.
  /// Logic: Today, Yesterday, Weekdays (if < 7 days), Month & Year.
  static String formatDateGroup(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return AppStrings.notifications.groupToday;
    } else if (date == yesterday) {
      return AppStrings.notifications.groupYesterday;
    } else {
      final difference = today.difference(date).inDays;
      if (difference < 7) {
        return DateFormat('EEEE').format(dateTime); // e.g. Monday
      } else {
        return DateFormat('MMMM, y').format(dateTime); // e.g. May, 2026
      }
    }
  }

  /// Copies the given [text] to the clipboard and shows a success snackbar.
  /// Defaults to "Copied!" if no [message] is provided.
  static void copyToClipboard(String text, {String? message}) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackbar.info(message ?? AppStrings.common.copied);
  }

  /// Formats a notification count (e.g., 100 -> '99+').
  static String formatNotificationCount(int count) {
    if (count <= 0) return '';
    if (count > 99) return '99+';
    return count.toString();
  }

  /// Formats a [DateTime] into a human-readable relative time string.
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
