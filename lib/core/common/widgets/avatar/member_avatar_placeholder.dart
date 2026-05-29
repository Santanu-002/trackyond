import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberAvatarPlaceholder extends StatelessWidget {
  final String name;
  final double radius;

  const MemberAvatarPlaceholder({
    super.key,
    required this.name,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
        style: context.textTheme.titleMedium?.copyWith(
          color: context.theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: radius * .75,
        ),
      ),
    );
  }
}
