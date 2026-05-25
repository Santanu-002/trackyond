import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/utils/app_utils.dart';
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
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;
    final metadata = message.metadata ?? {};
    final rawAddress = metadata['address'] as String? ?? '';
    final address = rawAddress.trim().isEmpty ? '-' : rawAddress;
    final activityType = metadata['activity_type'] as String? ?? '';

    final chatController = Get.find<JobChatController>();
    final workerName =
        metadata['workerName'] as String? ??
        chatController.getSenderName(message);
    Duration? breakDuration;
    if (activityType == 'break_out') {
      DateTime? takeBreakTime;
      for (final msg in chatController.messages) {
        if (msg.timestamp.isBefore(message.timestamp)) {
          final isTakeBreak =
              msg.type == 'activity' &&
              msg.metadata?['activity_type'] == 'take_break';
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
      case 'job_created':
        cardTitle = AppStrings.jobChat.activityJobAssigned;
        cardIcon = AppIcons.jobs.work;
        break;
      case 'reached_location':
        cardTitle = AppStrings.jobChat.activityReachedSite;
        cardIcon = AppIcons.jobs.checkIn;
        break;
      case 'started_job':
        cardTitle = AppStrings.jobChat.activityJobStarted;
        cardIcon = AppIcons.common.play;
        break;
      case 'completed_job':
        cardTitle = AppStrings.jobChat.activityJobCompleted;
        cardIcon = AppIcons.status.success;
        break;
      case 'take_break':
        cardTitle = AppStrings.jobChat.activityOnBreak;
        cardIcon = AppIcons.jobs.coffee;
        break;
      case 'break_out':
        cardTitle = AppStrings.jobChat.activityBreakEnded;
        cardIcon = AppIcons.common.play;
        break;
      case 'send_location':
        cardTitle = AppStrings.jobChat.activityLocationShared;
        cardIcon = AppIcons.jobs.myLocation;
        break;
      case 'ask_location':
        cardTitle = AppStrings.jobChat.activityLocationRequested;
        cardIcon = AppIcons.jobs.locationSearching;
        break;
      case 'ask_status':
        cardTitle = AppStrings.jobChat.activityStatusRequested;
        cardIcon = AppIcons.jobs.statusQuestion;
        break;
      case 'ask_status_proofs':
        cardTitle = AppStrings.jobChat.activityStatusProofsRequested;
        cardIcon = AppIcons.jobs.cameraOutlined;
        break;
      case 'cancel_job':
        cardTitle = AppStrings.jobChat.activityJobCancelled;
        cardIcon = AppIcons.dashboard.cancelled;
        break;
      case 'reopen_job':
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
        (activityType == 'send_location' || activityType == 'reached_location') &&
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

    Widget? mapPreviewWidget;
    if (isLocationActivity) {
      final mapUrl = AppUtils.getStaticMapUrl(
        latitude: latitude,
        longitude: longitude,
        apiKey: ApiEndpoints.googleMapsApiKey,
      );
      debugPrint('Generated Static Map URL: $mapUrl');

      mapPreviewWidget = GestureDetector(
        onTap: () => chatController.openMap(latitude, longitude),
        child: AppImage(
          imageUrl: mapUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 160,
          placeholder: (context, url) => Container(
            height: 160,
            color: colorScheme.surfaceDim,
            child: Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 160,
            color: colorScheme.surfaceDim,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.dashboard.location,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                  AppUIConstants.widgets.verticalBox$8,
                  Text(
                    AppStrings.jobChat.viewOnGoogleMaps,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Color theme overrides based on isMe to match normal bubble look
    final cardBgColor = isMe
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onSurface;
    final subtitleColor = isMe 
        ? colorScheme.onPrimary.withValues(alpha: 0.7) 
        : colorScheme.onSurfaceVariant;
    final primaryThemeColor = isMe ? colorScheme.onPrimary : colorScheme.primary;

    final iconContainerBg = isMe
        ? colorScheme.onPrimary.withValues(alpha: 0.15)
        : colorScheme.primary.withValues(alpha: 0.1);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: isLocationActivity
            ? () => chatController.openMap(latitude, longitude)
            : null,
        child: Container(
          margin: EdgeInsets.only(
            left: isMe ? AppUIConstants.spacing.space$48 : 36,
            right: 0,
          ),
          width: 300,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (mapPreviewWidget != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: imageWidget == null
                        ? Radius.circular(topLeftRadius)
                        : Radius.zero,
                    topRight: imageWidget == null
                        ? Radius.circular(topRightRadius)
                        : Radius.zero,
                  ),
                  child: mapPreviewWidget,
                ),
              ],
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
                          Text(
                            workerName,
                            style: textTheme.labelSmall?.copyWith(
                              color: subtitleColor,
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
                    children: Get.find<JobChatController>()
                        .parseMentionsToSpans(
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
            ],
          ),
        ),
      ),
    );
  }
}
