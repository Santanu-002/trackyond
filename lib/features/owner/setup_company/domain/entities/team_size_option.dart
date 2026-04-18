import 'package:flutter/material.dart';

class TeamSizeOption {
  final String title;
  final String subtitle;
  final int value;
  final IconData icon;

  TeamSizeOption({
    required this.title,
    required this.subtitle,
    required this.value,
    this.icon = Icons.groups_rounded,
  });
}
