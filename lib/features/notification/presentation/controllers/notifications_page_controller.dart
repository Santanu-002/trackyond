import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/filter/app_chip_entity.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';

class NotificationsPageController extends GetxController {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  final ScrollController scrollController = ScrollController();

  List<AppChipEntity<int>> get filterEntities => [
    AppChipEntity(
      label: AppStrings.notifications.filterAll,
      value: 0,
      onTap: () => setFilter(0),
    ),
    AppChipEntity(
      label: AppStrings.notifications.filterUnread,
      value: 1,
      onTap: () => setFilter(1),
    ),
    AppChipEntity(
      label: AppStrings.notifications.filterRead,
      value: 2,
      onTap: () => setFilter(2),
    ),
  ];

  // ── Selection ────────────────────────────────────────────────────────────

  final isSelectionMode = false.obs;
  final selectedIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onReady() {
    super.onReady();
    notificationController.fetchNotifications();
    notificationController.markAllAsSeen();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      notificationController.loadMoreNotifications();
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (selectedIds.isEmpty) exitSelectionMode();
    } else {
      selectedIds.add(id);
      isSelectionMode.value = true;
    }
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedIds.clear();
  }

  void copySelectedDetails() {
    final selected = notificationController.notifications
        .where((n) => selectedIds.contains(n.id))
        .toList();

    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    String buffer = '';

    for (var i = 0; i < selected.length; i++) {
      final n = selected[i];

      // Clean up body text (remove HTML tags, convert <br> to newline)
      String cleanBody = n.body.replaceAll(
        RegExp(r'<br\s*/?>', caseSensitive: false),
        '\n',
      );
      cleanBody = cleanBody.replaceAll(RegExp(r'<[^>]*>'), '');

      buffer += '${n.title}\n\n';
      buffer += '$cleanBody\n\n';

      if (n.data != null) {
        String? customerName;
        String? customerAddress;
        String? customerPhone;

        // Parse from 'job' JSON string
        final String? jobDataStr = n.data!['job']?.toString();
        if (jobDataStr != null && jobDataStr.isNotEmpty) {
          try {
            final Map<String, dynamic> jobData = jsonDecode(jobDataStr);
            customerName = jobData['customerName']?.toString();
            customerAddress = jobData['customerAddress']?.toString();
            customerPhone = jobData['customerPhone']?.toString();
          } catch (_) {}
        }

        bool hasCustomerData = false;
        if (customerName != null && customerName.isNotEmpty) {
          buffer += 'Customer: $customerName\n';
          hasCustomerData = true;
        }
        if (customerAddress != null && customerAddress.isNotEmpty) {
          buffer += 'Location: $customerAddress\n';
          hasCustomerData = true;
        }
        if (customerPhone != null && customerPhone.isNotEmpty) {
          buffer += 'Phone: $customerPhone\n';
          hasCustomerData = true;
        }
        if (hasCustomerData) buffer += '\n';
      }

      final localDate = n.createdAt.toLocal();
      buffer +=
          '${AppStrings.notifications.dateLabel}: ${formatter.format(localDate)}\n';

      if (i < selected.length - 1) buffer += '\n\n';
    }

    Clipboard.setData(ClipboardData(text: buffer.trim()));
    AppSnackbar.success(AppStrings.common.copied);
    exitSelectionMode();
  }

  /// Called when the user taps a notification in the list.
  /// Marks it as read (bold → normal), then navigates.
  Future<void> onNotificationTap(NotificationEntity notification) async {
    if (!notification.isRead) {
      await notificationController.markAsRead([notification.id]);
    }
    Get.toNamed(
      AppRoutes.common.notificationDetails,
      arguments: notification.data,
    );
  }

  Future<void> markSelectedAsRead() async {
    await notificationController.markAsRead(selectedIds.toList());
    exitSelectionMode();
  }

  Future<void> deleteSelected() async {
    await notificationController.deleteNotifications(selectedIds.toList());
    exitSelectionMode();
  }

  // ── Filter & Sort ────────────────────────────────────────────────────────

  /// 0 = All · 1 = Unread · 2 = Read
  final selectedFilterIndex = 0.obs;

  /// true = Newest first, false = Oldest first
  final isNewestFirst = true.obs;

  void setFilter(int index) {
    selectedFilterIndex.value = index;
    _fetchWithFilters();
  }

  void toggleSort() {
    isNewestFirst.value = !isNewestFirst.value;
  }

  void _fetchWithFilters() {
    bool? isRead;
    if (selectedFilterIndex.value == 1) {
      isRead = false;
    } else if (selectedFilterIndex.value == 2) {
      isRead = true;
    }

    notificationController.fetchNotifications(
      options: NotificationFilterOptions(isRead: isRead, isNewestFirst: true),
    );
  }

  /// Returns notifications grouped by date label (Today / Yesterday / Weekday / Month, Year).
  Map<String, List<NotificationEntity>> get groupedNotifications {
    final result = <String, List<NotificationEntity>>{};

    // 1. Group them.
    // We assume notificationController.notifications is ALREADY sorted newest first from the API.
    // This ensures that the groups themselves are ordered from newest to oldest.
    for (final n in notificationController.notifications) {
      final label = AppUtils.formatDateGroup(n.createdAt);
      result.putIfAbsent(label, () => []).add(n);
    }

    // 2. Sort items within each group based on the toggle preference
    final newestFirst = isNewestFirst.value;
    for (final list in result.values) {
      list.sort(
        (a, b) => newestFirst
            ? b.createdAt.compareTo(a.createdAt)
            : a.createdAt.compareTo(b.createdAt),
      );
    }

    return result;
  }

  // ── Tri-state header checkbox ────────────────────────────────────────────

  /// null = partial, true = all selected, false = none selected
  bool? get headerCheckboxValue {
    final visible = notificationController.notifications;
    if (visible.isEmpty) return false;
    final allSelected = visible.every((n) => selectedIds.contains(n.id));
    final noneSelected = visible.every((n) => !selectedIds.contains(n.id));
    if (allSelected) return true;
    if (noneSelected) return false;
    return null; // partial
  }

  void onHeaderCheckboxChanged(bool? value) {
    final visible = notificationController.notifications;
    // Partial → select all; selected → deselect all
    if (value == true || headerCheckboxValue == null) {
      for (final n in visible) {
        selectedIds.add(n.id);
      }
      isSelectionMode.value = true;
    } else {
      for (final n in visible) {
        selectedIds.remove(n.id);
      }
      if (selectedIds.isEmpty) exitSelectionMode();
    }
  }
}
