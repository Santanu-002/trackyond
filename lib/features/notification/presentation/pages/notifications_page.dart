import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip_row.dart';
import 'package:trackyond/core/common/widgets/chip/app_sort_chip.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/common/widgets/text/app_styled_text.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/presentation/controllers/notifications_page_controller.dart';

class NotificationsPage extends GetView<NotificationsPageController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelectionMode = controller.isSelectionMode.value;

      return AppScaffold(
        centerTitle: !isSelectionMode,
        titleSpacing: isSelectionMode ? 0.0 : null,
        title: isSelectionMode
            ? AppStrings.notifications.selectedCount(controller.selectedIds.length)
            : AppStrings.notifications.appBarTitle,
        automaticallyImplyLeading: !isSelectionMode,
        leading: isSelectionMode
            ? IconButton(
                icon: Icon(AppIcons.common.close),
                onPressed: controller.exitSelectionMode,
              )
            : null,

        useScrollView: false,
        padding: EdgeInsets.zero,
        actions: isSelectionMode
            ? [
          IconButton(
            icon: Icon(AppIcons.common.markRead),
            onPressed: controller.markSelectedAsRead,
            tooltip: AppStrings.notifications.markAsRead,
          ),
          IconButton(
            icon: Icon(AppIcons.common.delete),
            onPressed: controller.deleteSelected,
            tooltip: AppStrings.notifications.delete,
          ),
          IconButton(
            icon: Icon(AppIcons.common.copy),
            onPressed: controller.copySelectedDetails,
            tooltip: AppStrings.notifications.copyDetails,
          ),
        ]
            : [],
        child: Column(
          children: [
            _NotificationFilterBar(controller: controller),
            Expanded(
              child: Obx(() {
                final nc = controller.notificationController;
                final groups = controller.groupedNotifications;

                if (nc.isLoading.value && nc.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (groups.isEmpty) {
                  return Center(
                    child: Text(AppStrings.notifications.noNotifications),
                  );
                }

                // Flatten groups into a list of header + item entries
                final entries = <_ListEntry>[];
                for (final entry in groups.entries) {
                  entries.add(_ListEntry.header(entry.key));
                  for (final n in entry.value) {
                    entries.add(_ListEntry.item(n));
                  }
                }

                return RefreshIndicator(
                  onRefresh: nc.fetchNotifications,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollController,
                    padding: EdgeInsets.only(
                      bottom: AppUIConstants.spacing.space$16,
                    ),
                    itemCount: entries.length + (nc.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == entries.length) {
                        return Obx(() {
                          if (!nc.isMoreLoading.value) {
                            return const SizedBox.shrink();
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        });
                      }

                      final e = entries[index];
                      if (e.isHeader) {
                        return _DateGroupHeader(label: e.label!);
                      }
                      return Obx(() {
                        final isSelected =
                        controller.selectedIds.contains(e.notification!.id);
                        return _NotificationTile(
                          notification: e.notification!,
                          isSelected: isSelected,
                          isSelectionMode: controller.isSelectionMode.value,
                          onTap: () {
                            if (controller.isSelectionMode.value) {
                              controller.toggleSelection(e.notification!.id);
                            } else {
                              controller.onNotificationTap(e.notification!);
                            }
                          },
                          onLongPress: () =>
                              controller.toggleSelection(e.notification!.id),
                        );
                      });
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────

class _NotificationFilterBar extends StatelessWidget {
  final NotificationsPageController controller;

  const _NotificationFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelectionMode = controller.isSelectionMode.value;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$16,
          vertical: AppUIConstants.spacing.space$8,
        ),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            // Tri-state header checkbox — only visible in selection mode
            if (isSelectionMode) ...[
              Checkbox(
                tristate: true,
                value: controller.headerCheckboxValue,
                onChanged: controller.onHeaderCheckboxChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              ),
              AppUIConstants.widgets.horizontalBox$12,
            ],

            // Filter chips
            Expanded(
              child: Obx(() {
                final currentFilter = controller.selectedFilterIndex.value;
                return AppFilterChipRow.fromEntityList(
                  items: controller.filterEntities,
                  isSelected: (index) =>
                  currentFilter == controller.filterEntities[index].value,
                );
              }),
            ),

            AppUIConstants.widgets.horizontalBox$12,

            // Sort toggle button
            Obx(() {
              return AppSortChip(
                isDescending: controller.isNewestFirst.value,
                descendingLabel: AppStrings.notifications.sortNewest,
                ascendingLabel: AppStrings.notifications.sortOldest,
                onToggle: controller.toggleSort,
              );
            }),
          ],
        ),
      );
    });
  }
}

// ── Date Group Header ─────────────────────────────────────────────────────────

class _DateGroupHeader extends StatelessWidget {
  final String label;

  const _DateGroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppUIConstants.spacing.space$16,
        AppUIConstants.spacing.space$16,
        AppUIConstants.spacing.space$16,
        AppUIConstants.spacing.space$12,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: cs.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Notification Tile ─────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _NotificationTile({
    required this.notification,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final isUnread = !notification.isRead;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: isUnread
          ? cs.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: cs.primary.withValues(alpha: 0.12),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$16,
            vertical: 0,
          ),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isSelectionMode) ...[
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
                AppUIConstants.widgets.horizontalBox$12,
              ],
              _LeadingArea(
                isRead: notification.isRead,
                primaryColor: cs.primary,
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                    color: isUnread ? cs.onSurface : cs.onSurfaceVariant,
                  ),
                ),
              ),
              AppUIConstants.widgets.horizontalBox$8,
              Text(
                AppUtils.formatRelativeTime(notification.createdAt),
                style: context.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              AppStyledText(
                text: notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isUnread
                      ? cs.onSurface.withValues(alpha: 0.75)
                      : cs.onSurfaceVariant.withValues(alpha: 0.65),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Leading Area: icon + checkbox ─────────────────────────────────────────────

class _LeadingArea extends StatelessWidget {
  final bool isRead;
  final Color primaryColor;

  const _LeadingArea({
    required this.isRead,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isRead
            ? cs.surfaceContainerHighest
            : primaryColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isRead
            ? AppIcons.common.notifications
            : AppIcons.common.notificationsActive,
        size: 20,
        color: isRead ? cs.onSurfaceVariant : primaryColor,
      ),
    );
  }
}

// ── Internal list entry model ─────────────────────────────────────────────────

class _ListEntry {
  final bool isHeader;
  final String? label;
  final NotificationEntity? notification;

  const _ListEntry._({required this.isHeader, this.label, this.notification});

  factory _ListEntry.header(String label) =>
      _ListEntry._(isHeader: true, label: label);

  factory _ListEntry.item(NotificationEntity n) =>
      _ListEntry._(isHeader: false, notification: n);
}
