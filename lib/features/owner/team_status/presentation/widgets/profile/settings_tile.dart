import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? context.theme.colorScheme.error
        : context.theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(color: color),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    );
  }
}
