import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AvatarUtils {
  const AvatarUtils._();

  /// Returns a deterministic [Color] for a given [name] using the same
  /// palette as [MemberAvatar], ensuring visual consistency across the app.
  static Color getAvatarColor(String name) {
    final int colorIndex =
        name.hashCode.abs() % AppUIConstants.colors.avatarColors.length;
    return AppUIConstants.colors.avatarColors[colorIndex];
  }

  /// Returns the "next" color in the palette for a given [name].
  static Color consecutiveColorFromName(String name) {
    final int colorIndex =
        (name.hashCode.abs() + 1) % AppUIConstants.colors.avatarColors.length;
    return AppUIConstants.colors.avatarColors[colorIndex];
  }

  /// Returns the complementary (opposite) color on the hue circle.
  static Color getComplementaryColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    final newHue = (hsl.hue + 180) % 360;
    return hsl.withHue(newHue).toColor();
  }

  /// Returns initials from a name (up to 2 characters).
  static String getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}

/// Legacy top-level function for backward compatibility if needed
Color avatarColorFromName(String name) => AvatarUtils.getAvatarColor(name);
