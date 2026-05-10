import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_icons.dart';

class TeamSizeOption {
  final String title;
  final String subtitle;
  final int value;
  final IconData icon;

  TeamSizeOption({
    required this.title,
    required this.subtitle,
    required this.value,
    IconData? icon,
  }) : icon = icon ?? AppIcons.common.team;
}
