import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/activity_meta_row.dart';

class ActivityMessageCard extends StatelessWidget {
  final JobChatMessageEntity message;
  final JobChatMessageContentEntity content;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const ActivityMessageCard({
    super.key,
    required this.message,
    required this.content,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final isSystem = message.authorType == 'system';
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;
    final metadata = message.metadata ?? {};
    final rawAddress = metadata['address'] as String? ?? '';
    final address = rawAddress.trim().isEmpty ? '-' : rawAddress;
    final activityType = JobActivityType.fromString(metadata['activity_type']);

    final chatController = Get.find<JobChatController>();
    final senderName = chatController.getSenderName(message);
    final senderImage = chatController.getSenderImage(message);

    Duration? breakDuration;
    if (activityType == JobActivityType.breakOut) {
      DateTime? takeBreakTime;
      for (final msg in chatController.messages) {
        if (msg.timestamp.isBefore(message.timestamp)) {
          final isTakeBreak =
              msg.type == 'activity' &&
              JobActivityType.fromString(msg.metadata?['activity_type']) == JobActivityType.takeBreak;
          if (isTakeBreak) {
            if (takeBreakTime == null || msg.timestamp.isAfter(takeBreakTime)) {
              takeBreakTime = msg.timestamp;
            }
          }
        }
      }
      if (takeBreakTime != null) {
        breakDuration = message.timestamp.difference(takeBreakTime);
      }
    }

    String formatDuration(Duration d) {
      final roundedMinutes = (d.inSeconds / 60.0).round();
      final hours = roundedMinutes ~/ 60;
      final minutes = roundedMinutes % 60;
      if (hours > 0) {
        if (minutes > 0) {
          return '${hours}h ${minutes}min';
        } else {
          return '${hours}h';
        }
      } else {
        return '${roundedMinutes > 0 ? roundedMinutes : 1}min';
      }
    }

    final String cardTitle;
    final IconData cardIcon;

    switch (activityType) {
      case JobActivityType.jobCreated:
        cardTitle = AppStrings.jobChat.activityJobAssigned;
        cardIcon = AppIcons.jobs.work;
        break;
      case JobActivityType.reachedLocation:
        cardTitle = AppStrings.jobChat.activityReachedSite;
        cardIcon = AppIcons.jobs.checkIn;
        break;
      case JobActivityType.startedJob:
        cardTitle = AppStrings.jobChat.activityJobStarted;
        cardIcon = AppIcons.common.play;
        break;
      case JobActivityType.completedJob:
        cardTitle = AppStrings.jobChat.activityJobCompleted;
        cardIcon = AppIcons.status.success;
        break;
      case JobActivityType.takeBreak:
        cardTitle = AppStrings.jobChat.activityOnBreak;
        cardIcon = AppIcons.jobs.coffee;
        break;
      case JobActivityType.breakOut:
        cardTitle = AppStrings.jobChat.activityBreakEnded;
        cardIcon = AppIcons.common.play;
        break;
      case JobActivityType.sendLocation:
        cardTitle = AppStrings.jobChat.activityLocationShared;
        cardIcon = AppIcons.jobs.myLocation;
        break;
      case JobActivityType.askLocation:
        cardTitle = AppStrings.jobChat.activityLocationRequested;
        cardIcon = AppIcons.jobs.locationSearching;
        break;
      case JobActivityType.askStatus:
        cardTitle = AppStrings.jobChat.activityStatusRequested;
        cardIcon = AppIcons.jobs.statusQuestion;
        break;
      case JobActivityType.askStatusProofs:
        cardTitle = AppStrings.jobChat.activityStatusProofsRequested;
        cardIcon = AppIcons.jobs.cameraOutlined;
        break;
      case JobActivityType.cancelJob:
        cardTitle = AppStrings.jobChat.activityJobCancelled;
        cardIcon = AppIcons.dashboard.cancelled;
        break;
      case JobActivityType.reopenJob:
        cardTitle = AppStrings.jobChat.activityJobReopened;
        cardIcon = AppIcons.common.refresh;
        break;
      default:
        cardTitle = AppStrings.jobChat.activityUpdate;
        cardIcon = Icons.info_outline;
    }

    String displayTime;
    final assignedTimeStr =
        metadata['assignedTime'] as String? ??
        metadata['assigned_time'] as String?;
    if (assignedTimeStr != null) {
      if (assignedTimeStr == '-' || assignedTimeStr.trim().isEmpty) {
        displayTime = '-';
      } else {
        try {
          final parsedDate = DateTime.parse(assignedTimeStr).toLocal();
          displayTime = DateFormat(
            AppStrings.jobChat.timeFormat,
          ).format(parsedDate);
        } catch (e) {
          displayTime = assignedTimeStr;
        }
      }
    } else {
      displayTime = DateFormat(
        AppStrings.jobChat.timeFormat,
      ).format(message.timestamp);
    }

    final double softRadius = AppUIConstants.radius.radius$16;
    final double hardRadius = 2.0;

    final double topLeftRadius = (!isMe && hasSameSenderAbove)
        ? hardRadius
        : softRadius;
    final double bottomLeftRadius = (!isMe && hasSameSenderBelow)
        ? hardRadius
        : softRadius;
    final double topRightRadius = (isMe && hasSameSenderAbove)
        ? hardRadius
        : softRadius;
    final double bottomRightRadius = (isMe && hasSameSenderBelow)
        ? hardRadius
        : softRadius;

    final latitude = metadata['latitude'] as double?;
    final longitude = metadata['longitude'] as double?;
    final isLocationActivity =
        (activityType == JobActivityType.sendLocation ||
            activityType == JobActivityType.reachedLocation) &&
        latitude != null &&
        longitude != null;

    final imageContentIndex = message.content.indexWhere(
      (c) => c.type == 'image',
    );
    final imageContent = imageContentIndex != -1
        ? message.content[imageContentIndex]
        : null;
    Widget? imageWidget;

    if (imageContent != null) {
      final url = imageContent.metadata?['url'] as String? ?? '';
      final fileMetadata =
          imageContent.metadata?['fileMetadata'] as Map<String, dynamic>?;
      final imageMetadata =
          fileMetadata?['imageMetadata'] as Map<String, dynamic>?;
      final width = imageMetadata?['width'] as num?;
      final height = imageMetadata?['height'] as num?;

      if (url.isNotEmpty) {
        Widget cachedImage = AppImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => Container(
            color: colorScheme.surfaceDim,
            child: Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 150,
            color: colorScheme.surfaceDim,
            child: const Center(child: Icon(Icons.error_outline)),
          ),
        );

        if (width != null && height != null && height > 0) {
          double calculatedAspectRatio = width / height;
          if (calculatedAspectRatio < 0.8) {
            calculatedAspectRatio = 0.8;
          }
          imageWidget = AspectRatio(
            aspectRatio: calculatedAspectRatio,
            child: cachedImage,
          );
        } else {
          imageWidget = SizedBox(
            height: 180,
            width: double.infinity,
            child: cachedImage,
          );
        }
      }
    }

    // Color theme overrides based on isMe to match normal bubble look
    final cardBgColor = isMe
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onSurface;
    final subtitleColor = isMe
        ? colorScheme.onPrimary.withValues(alpha: 0.7)
        : colorScheme.onSurfaceVariant;
    final primaryThemeColor = isMe
        ? colorScheme.onPrimary
        : colorScheme.primary;

    final iconContainerBg = isMe
        ? colorScheme.onPrimary.withValues(alpha: 0.15)
        : colorScheme.primary.withValues(alpha: 0.1);

    final double screenWidth = context.width;
    final double maxBubbleWidth = isMe
        ? (screenWidth - 100).clamp(220.0, 275.0)
        : (screenWidth - 120).clamp(220.0, 275.0);

    final bubbleWidget = Container(
      constraints: BoxConstraints(
        minWidth: 220,
        maxWidth: maxBubbleWidth,
      ),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
          bottomLeft: Radius.circular(bottomLeftRadius),
          bottomRight: Radius.circular(bottomRightRadius),
        ),
        boxShadow: AppUIConstants.shadows.xs,
      ),
      // Do NOT use IntrinsicWidth here: it probes children with infinite width,
      // which causes AspectRatio (used for image content) to produce an infinite
      // height and crash Flutter's layout engine. The Container's minWidth:300
      // constraint already ensures the bubble has a sensible width.
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageWidget != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius),
                  topRight: Radius.circular(topRightRadius),
                ),
                child: imageWidget,
              ),
            ],
            // --- REPLY PREVIEW START ---
            () {
              final replyContent = message.content.firstWhereOrNull(
                (c) => c.type == 'refer/reply',
              );
              if (replyContent == null) return const SizedBox.shrink();

              final metadata = replyContent.metadata ?? {};
              final replyToUid = metadata['messageUid'] as String? ?? '';
              final displayName = metadata['senderName'] as String? ?? 'User';
              final replyImageUrl = metadata['imageUrl'] as String?;
              final String replyType = metadata['type'] as String? ?? 'message';

              Widget replyBodyWidget;
              if (replyType == 'activity') {
                final rActivityType =
                    JobActivityType.fromString(metadata['activityType']);
                IconData rActivityIcon;
                String rActivityTitle;

                switch (rActivityType) {
                  case JobActivityType.jobCreated:
                    rActivityTitle = AppStrings.jobChat.activityJobAssigned;
                    rActivityIcon = AppIcons.jobs.work;
                    break;
                  case JobActivityType.reachedLocation:
                    rActivityTitle = AppStrings.jobChat.activityReachedSite;
                    rActivityIcon = AppIcons.jobs.checkIn;
                    break;
                  case JobActivityType.startedJob:
                    rActivityTitle = AppStrings.jobChat.activityJobStarted;
                    rActivityIcon = AppIcons.common.play;
                    break;
                  case JobActivityType.completedJob:
                    rActivityTitle = AppStrings.jobChat.activityJobCompleted;
                    rActivityIcon = AppIcons.status.success;
                    break;
                  case JobActivityType.takeBreak:
                    rActivityTitle = AppStrings.jobChat.activityOnBreak;
                    rActivityIcon = AppIcons.jobs.coffee;
                    break;
                  case JobActivityType.breakOut:
                    rActivityTitle = AppStrings.jobChat.activityBreakEnded;
                    rActivityIcon = AppIcons.common.play;
                    break;
                  case JobActivityType.sendLocation:
                    rActivityTitle = AppStrings.jobChat.activityLocationShared;
                    rActivityIcon = AppIcons.jobs.myLocation;
                    break;
                  case JobActivityType.askLocation:
                    rActivityTitle =
                        AppStrings.jobChat.activityLocationRequested;
                    rActivityIcon = AppIcons.jobs.locationSearching;
                    break;
                  case JobActivityType.askStatus:
                    rActivityTitle = AppStrings.jobChat.activityStatusRequested;
                    rActivityIcon = AppIcons.jobs.statusQuestion;
                    break;
                  case JobActivityType.askStatusProofs:
                    rActivityTitle =
                        AppStrings.jobChat.activityStatusProofsRequested;
                    rActivityIcon = AppIcons.jobs.cameraOutlined;
                    break;
                  case JobActivityType.cancelJob:
                    rActivityTitle = AppStrings.jobChat.activityJobCancelled;
                    rActivityIcon = AppIcons.dashboard.cancelled;
                    break;
                  case JobActivityType.reopenJob:
                    rActivityTitle = AppStrings.jobChat.activityJobReopened;
                    rActivityIcon = AppIcons.common.refresh;
                    break;
                  default:
                    rActivityTitle = AppStrings.jobChat.activityUpdate;
                    rActivityIcon = Icons.info_outline;
                }

                replyBodyWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      rActivityIcon,
                      size: 12,
                      color: isMe
                          ? colorScheme.onPrimary.withValues(alpha: 0.7)
                          : colorScheme.primary,
                    ),
                    AppUIConstants.widgets.horizontalBox$4,
                    Text(
                      rActivityTitle,
                      style: textTheme.labelSmall?.copyWith(
                        color: isMe
                            ? colorScheme.onPrimary.withValues(alpha: 0.7)
                            : colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              } else {
                replyBodyWidget = Text(
                  replyContent.content ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: isMe
                        ? colorScheme.onPrimary.withValues(alpha: 0.7)
                        : colorScheme.onSurfaceVariant,
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: GestureDetector(
                  onTap: () => chatController.scrollToMessage(replyToUid),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMe
                            ? colorScheme.onPrimary.withValues(alpha: 0.15)
                            : colorScheme.primary.withValues(alpha: 0.08),
                        border: Border(
                          left: BorderSide(
                            color: isMe
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                            width: 4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (replyImageUrl != null) ...[
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: AppImage(
                                  imageUrl: replyImageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            AppUIConstants.widgets.horizontalBox$8,
                          ],
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayName,
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isMe
                                        ? colorScheme.onPrimary
                                        : colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                replyBodyWidget,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }(),
            // --- REPLY PREVIEW END ---
            Padding(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
                    decoration: BoxDecoration(
                      color: iconContainerBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cardIcon, color: primaryThemeColor, size: 20),
                  ),
                  AppUIConstants.widgets.horizontalBox$8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cardTitle,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryThemeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$12,
              ),
              child: RichText(
                text: TextSpan(
                  children: chatController.parseMentionsToSpans(
                    content.content ??
                        AppStrings.jobChat.activityDefaultReached,
                    textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryThemeColor,
                    ),
                  ),
                ),
              ),
            ),
            AppUIConstants.widgets.verticalBox$8,
            if (activityType != JobActivityType.askLocation &&
                activityType != JobActivityType.askStatus &&
                activityType != JobActivityType.askStatusProofs)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppUIConstants.spacing.space$12,
                  0,
                  AppUIConstants.spacing.space$12,
                  AppUIConstants.spacing.space$12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActivityMetaRow(
                      icon: AppIcons.dashboard.clock,
                      text: displayTime,
                      iconColor: primaryThemeColor,
                      textStyle: textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                      ),
                    ),
                    if (breakDuration != null) ...[
                      AppUIConstants.widgets.verticalBox$4,
                      ActivityMetaRow(
                        icon: AppIcons.dashboard.timer,
                        text: formatDuration(breakDuration),
                        iconColor: primaryThemeColor,
                        textStyle: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                    AppUIConstants.widgets.verticalBox$4,
                    ActivityMetaRow(
                      icon: AppIcons.jobs.locationPinFilled,
                      text: address,
                      iconColor: primaryThemeColor,
                      textStyle: textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            if (isLocationActivity) ...[
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              GestureDetector(
                onTap: () => chatController.openMap(latitude, longitude),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: AppUIConstants.spacing.space$12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        AppIcons.jobs.locationPinFilled,
                        color: primaryThemeColor,
                        size: 18,
                      ),
                      AppUIConstants.widgets.horizontalBox$8,
                      Text(
                        AppStrings.jobChat.viewOnGoogleMaps,
                        style: textTheme.labelLarge?.copyWith(
                          color: primaryThemeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (activityType == JobActivityType.askLocation &&
                !isMe &&
                chatController.userRole == UserRole.worker) ...[
              Obx(() {
                // Ensure widget reacts to new messages
                final _ = chatController.messages.length;
                final isFulfilled = chatController.isAskLocationFulfilled(
                  message.timestamp,
                );

                final isThisActionLoading =
                    chatController.isActionLoading.value &&
                    chatController.loadingActionLabel.value ==
                        JobAction.sendLocation.value &&
                    chatController.loadingActionMessageUid.value == message.uid;
                final loadingMessage =
                    chatController.actionLoadingMessage.value;

                final btnColor = isFulfilled
                    ? colorScheme.onSurfaceVariant
                    : primaryThemeColor;

                return Column(
                  children: [
                    Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    GestureDetector(
                      onTap: (isFulfilled || isThisActionLoading)
                          ? null
                          : () => chatController.executeAction(
                              JobAction.sendLocation.value,
                              messageUid: message.uid,
                            ),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: AppUIConstants.spacing.space$12,
                        ),
                        child: isThisActionLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: primaryThemeColor,
                                    ),
                                  ),
                                  AppUIConstants.widgets.horizontalBox$8,
                                  Text(
                                    loadingMessage ?? AppStrings.common.loading,
                                    style: textTheme.labelLarge?.copyWith(
                                      color: primaryThemeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    AppIcons.jobs.myLocation,
                                    color: btnColor,
                                    size: 18,
                                  ),
                                  AppUIConstants.widgets.horizontalBox$8,
                                  Text(
                                    "Share Location",
                                    style: textTheme.labelLarge?.copyWith(
                                      color: btnColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ] else if ((activityType == JobActivityType.askStatus ||
                    activityType == JobActivityType.askStatusProofs) &&
                !isMe &&
                chatController.userRole == UserRole.worker) ...[
              Obx(() {
                final _ = chatController.messages.length;
                final isFulfilled = chatController.isAskStatusFulfilled(
                  message.timestamp,
                );
                final btnColor = isFulfilled
                    ? colorScheme.onSurfaceVariant
                    : primaryThemeColor;

                return Column(
                  children: [
                    Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    GestureDetector(
                      onTap: isFulfilled
                          ? null
                          : () => chatController.setReplyingTo(message),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: AppUIConstants.spacing.space$12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.reply_rounded,
                              color: btnColor,
                              size: 18,
                            ),
                            AppUIConstants.widgets.horizontalBox$8,
                            Text(
                              "Send Update",
                              style: textTheme.labelLarge?.copyWith(
                                color: btnColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ],
        ),
    );

    if (isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(
            left: AppUIConstants.spacing.space$48,
            right: 0,
          ),
          child: bubbleWidget,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasSameSenderAbove)
              Padding(
                padding: const EdgeInsets.only(
                  left: 36,
                  // Aligned with start of bubble (28 avatar + 8 spacing)
                  bottom: 4,
                ),
                child: Text(
                  senderName,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasSameSenderAbove)
                  MemberAvatar(
                    name: senderName,
                    image: senderImage,
                    icon: isSystem ? Icons.smart_toy_rounded : null,
                    radius: 14, // Standard avatar radius (28px width)
                  )
                else
                  SizedBox(width: AppUIConstants.spacing.space$28),
                AppUIConstants.widgets.horizontalBox$8,
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: bubbleWidget,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
