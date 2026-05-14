import 'package:flutter/widgets.dart';

class AppChipEntity<T> {
  final String label;
  final T value;
  final IconData? icon;
  final VoidCallback? onTap;

  const AppChipEntity({
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
  });
}
