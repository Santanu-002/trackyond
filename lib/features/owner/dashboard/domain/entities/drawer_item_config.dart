import 'package:flutter/widgets.dart';

class DrawerItemConfig {
  final IconData icon;
  final String label;
  final String route;

  DrawerItemConfig({
    required this.icon,
    required this.label,
    this.route = '',
  });
}
