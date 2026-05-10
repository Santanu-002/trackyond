import 'package:flutter/material.dart';

class TeamMemberProfileAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  TeamMemberProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
