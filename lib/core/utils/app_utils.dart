import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';

class AppUtils {
  const AppUtils._();

  /// Returns the corresponding [MediaPreviewType] for a given file [path].
  static MediaPreviewType getMediaPreviewType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (ext == 'pdf') {
      return MediaPreviewType.pdf;
    }
    if (ext == 'mp4' ||
        ext == 'mov' ||
        ext == 'avi' ||
        ext == 'mkv' ||
        ext == 'webm' ||
        ext == '3gp') {
      return MediaPreviewType.video;
    }
    if (ext == 'jpg' ||
        ext == 'jpeg' ||
        ext == 'png' ||
        ext == 'gif' ||
        ext == 'webp' ||
        ext == 'bmp' ||
        ext == 'heic' ||
        ext == 'heif') {
      return MediaPreviewType.image;
    }
    return MediaPreviewType.document;
  }

  /// Checks if a given file [path] is a video.
  static bool isVideoPath(String path) {
    return getMediaPreviewType(path) == MediaPreviewType.video;
  }

  /// Checks if a given file [path] is a document (including PDFs).
  static bool isDocPath(String path) {
    final type = getMediaPreviewType(path);
    return type == MediaPreviewType.document || type == MediaPreviewType.pdf;
  }

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

  /// Generates a Google Maps URL for the given [latitude] and [longitude].
  static String getGoogleMapsUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  /// Formats the given [bytes] into a human-readable file size string.
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Formats video duration in seconds to a "m:ss" format.
  /// Defaults to '0:05' if null or 0.
  static String formatVideoDuration(int? seconds) {
    final secs = (seconds == null || seconds <= 0) ? 5 : seconds;
    final int minutes = secs ~/ 60;
    final int remainingSeconds = secs % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
