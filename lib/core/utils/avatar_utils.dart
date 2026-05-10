import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

/// Returns a deterministic [Color] for a given [name] using the same
/// palette as [MemberAvatar], ensuring visual consistency across the app.
Color avatarColorFromName(String name) {
  final int colorIndex =
      name.hashCode.abs() % AppUIConstants.colors.avatarColors.length;
  return AppUIConstants.colors.avatarColors[colorIndex];
}

/// Returns the "next" color in the palette for a given [name].
Color consecutiveColorFromName(String name) {
  final int colorIndex =
      (name.hashCode.abs() + 1) % AppUIConstants.colors.avatarColors.length;
  return AppUIConstants.colors.avatarColors[colorIndex];
}

/// Returns the complementary (opposite) color on the hue circle.
Color getComplementaryColor(Color color) {
  final hsl = HSLColor.fromColor(color);
  final newHue = (hsl.hue + 180) % 360;
  return hsl.withHue(newHue).toColor();
}
