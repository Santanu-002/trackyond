import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/chip/app_status_chip.dart';
import 'package:trackyond/core/common/widgets/chip/app_tag.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/app_colors.dart';
import 'package:trackyond/core/utils/avatar_utils.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/member/attendance_status_time.dart';

class MemberProfileHeader extends GetView<TeamMemberProfilePageController> {
  final TeamMemberStatusEntity memberStatus;

  const MemberProfileHeader({super.key, required this.memberStatus});

  @override
  Widget build(BuildContext context) {
    // Fixed constants
    final double expandedHeight = context.height * 0.32;
    final double avatarRadius = AppUIConstants.radius.radius$56;
    final double collapsedAvatarRadius = AppUIConstants.radius.radius$24;

    final member = memberStatus.profile;

    // Use the "consecutive" color for the cover card to ensure contrast with the avatar background
    final Color avatarColor = consecutiveColorFromName(member.name);
    final bool isDarkHeader = avatarColor.computeLuminance() < 0.5;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double statusBarHeight = context.mediaQueryPadding.top;
          final double collapsedHeight = statusBarHeight + kToolbarHeight;
          final double currentHeight = constraints.maxHeight;

          // progress: 1.0 = fully expanded, 0.0 = fully collapsed
          final double progress =
              ((currentHeight - collapsedHeight) /
                      (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);

          // --- Avatar ---
          final double currentAvatarRadius = lerpDouble(
            collapsedAvatarRadius,
            avatarRadius,
            progress,
          )!;

          // Expanded center: horizontally centered
          final double expandedAvatarCenterX = context.width / 2;

          // Pushing the avatar further down towards the bottom of the expanded space
          // to reduce the gap with the actions sliver.
          final double expandedAvatarCenterY =
              statusBarHeight +
              kToolbarHeight * 0.5 +
              (expandedHeight - collapsedHeight) * 0.32;

          // Collapsed center: beside the back button in the toolbar
          final double collapsedAvatarCenterX =
              statusBarHeight +
              kToolbarHeight * 0.5 +
              AppUIConstants.spacing.space$4;
          final double collapsedAvatarCenterY =
              statusBarHeight + kToolbarHeight / 2;

          final double avatarCenterX = lerpDouble(
            collapsedAvatarCenterX,
            expandedAvatarCenterX,
            progress,
          )!;
          final double avatarCenterY = lerpDouble(
            collapsedAvatarCenterY,
            expandedAvatarCenterY,
            progress,
          )!;

          // --- Header info (below avatar) ---
          // Starts fading and sliding immediately as scroll begins.
          // Fully gone by the time 30% of the collapse is done (progress == 0.7).
          final double infoProgress = ((progress - 0.7) / 0.3).clamp(0.0, 1.0);
          final double headerInfoOpacity = infoProgress;

          // Slides up as it fades
          final double headerInfoSlide = lerpDouble(20.0, 0.0, infoProgress)!;

          // More breathing room between avatar and text
          final double textBlockTop =
              expandedAvatarCenterY +
              avatarRadius +
              AppUIConstants.spacing.space$16;

          // --- Collapsed title (appears in the last 10% of collapse) ---
          // progress < 0.1 => visible; progress >= 0.1 => hidden
          final double collapsedTitleOpacity = (1.0 - (progress / 0.1)).clamp(
            0.0,
            1.0,
          );
          final double collapsedTitleLeft =
              collapsedAvatarCenterX +
              collapsedAvatarRadius +
              AppUIConstants.spacing.space$12;

          final Color expandedIconColor = isDarkHeader
              ? AppColors.light.onPrimary
              : AppColors.light.textDefault;
          final Color collapsedIconColor = context.theme.colorScheme.onSurface;
          final Color currentIconColor = Color.lerp(
            collapsedIconColor,
            expandedIconColor,
            progress,
          )!;

          final isOwner = member.designation.toLowerCase() == 'owner';

          final SystemUiOverlayStyle overlayStyle = progress > 0.5
              ? (isDarkHeader
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark)
              : (context.theme.brightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark);

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: overlayStyle,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 0. Cover card — bottom edge aligns with avatar center,
                //    so avatar sits half-inside, half-outside the card.
                //    Fades out as the header collapses.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: avatarCenterY,
                  child: Opacity(
                    opacity: progress.clamp(0.0, 1.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: avatarColor),
                    ),
                  ),
                ),

                // 1. Back button (always visible, fixed position)
                Positioned(
                  top: statusBarHeight,
                  left: AppUIConstants.spacing.space$4,
                  width: kToolbarHeight,
                  height: kToolbarHeight,
                  child: Center(
                    child: AppButton.ghost(
                      width: 40,
                      height: 40,
                      onPressed: Get.back,
                      color: currentIconColor,
                      padding: EdgeInsets.zero,
                      child: Icon(
                        AppIcons.common.back,
                        size: AppUIConstants.spacing.space$20,
                        color: currentIconColor,
                      ),
                    ),
                  ),
                ),

                // 2. Traveling Avatar
                Positioned(
                  left: avatarCenterX - currentAvatarRadius,
                  top: avatarCenterY - currentAvatarRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: AppUIConstants.shadows.md,
                    ),
                    child: MemberAvatar(
                      name: member.name,
                      image: member.image,
                      radius: currentAvatarRadius,
                    ),
                  ),
                ),

                // 3. Expanded header info: name + designation + phone
                //    Fades out and slides up as the header collapses (gone by 60%)
                Positioned(
                  top:
                      textBlockTop -
                      headerInfoSlide -
                      (currentHeight - expandedHeight)
                          .clamp(double.negativeInfinity, 0)
                          .abs(),
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: headerInfoOpacity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: context.theme.colorScheme.surface.withValues(
                            alpha: 0,
                          ),
                          child: Text(
                            member.name,
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: context.theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        AppUIConstants.widgets.verticalBox$4,
                        GestureDetector(
                          onLongPress: controller.onCopyPhone,
                          child: Text(
                            member.phone,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        AppUIConstants.widgets.verticalBox$8,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppUIConstants.spacing.space$8,
                          children: [
                            AppTag(
                              label: member.designation,
                              icon: isOwner ? AppIcons.status.verified : null,
                              color: isOwner
                                  ? context.theme.colorScheme.primary
                                  : null,
                            ),
                            AppStatusChip.attendance(
                              attendanceStatus: memberStatus.status,
                              context: context,
                            ),
                          ],
                        ),
                        AppUIConstants.widgets.verticalBox$4,
                        AttendanceStatusTime(time: memberStatus.startAt),
                      ],
                    ),
                  ),
                ),

                // 4. Collapsed title: appears beside avatar when progress < 10%
                Positioned(
                  left: collapsedTitleLeft,
                  top: statusBarHeight,
                  height: kToolbarHeight,
                  child: Opacity(
                    opacity: collapsedTitleOpacity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            member.phone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

