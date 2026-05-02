import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/utils/avatar_utils.dart';

class MemberProfileHeader extends StatelessWidget {
  final MemberProfile member;

  const MemberProfileHeader({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    // Fixed constants
    const double expandedHeight = 240.0;
    final double avatarRadius = AppUIConstants.radius.radius$56;
    final double collapsedAvatarRadius = AppUIConstants.radius.radius$24;

    // Use the "consecutive" color for the cover card to ensure contrast with the avatar background
    final Color avatarColor = getComplementaryColor(
      avatarColorFromName(member.name),
    );
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
              (expandedHeight - collapsedHeight) * 0.5;

          // Collapsed center: beside the back button in the toolbar
          final double collapsedAvatarCenterX =
              statusBarHeight + kToolbarHeight * 0.5 + 4;
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

          // --- Header info (below avatar, fades out by 60% progress) ---
          // Only visible when progress > 0.0; fully gone at progress == 0.6
          final double headerInfoOpacity = (progress / 0.6).clamp(0.0, 1.0);

          // Slides up as it fades: at progress=1 it's at natural position,
          // at progress=0.6 it has moved up by ~20px and is invisible.
          final double headerInfoSlide = lerpDouble(
            20.0,
            0.0,
            (progress / 0.6).clamp(0.0, 1.0),
          )!;

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
              collapsedAvatarCenterX + collapsedAvatarRadius + 10;

          final Color expandedIconColor = isDarkHeader
              ? Colors.white
              : Colors.black;
          final Color collapsedIconColor = context.theme.colorScheme.onSurface;
          final Color currentIconColor = Color.lerp(
            collapsedIconColor,
            expandedIconColor,
            progress,
          )!;

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
                  left: 4,
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
                        size: 18,
                        color: currentIconColor,
                      ),
                    ),
                  ),
                ),

                // 2. Traveling Avatar
                Positioned(
                  left: avatarCenterX - currentAvatarRadius,
                  top: avatarCenterY - currentAvatarRadius,
                  child: Hero(
                    tag: 'avatar_${member.accountUid}',
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
                        Text(
                          member.name,
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${member.designation} • ${member.phone}',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                            member.designation,
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
