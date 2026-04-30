import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

enum AttendanceInfoType { location, clock, timer, calendar }

class AttendanceInfoItem {
  final IconData icon;
  final String text;
  final AttendanceInfoType type;

  AttendanceInfoItem({
    required this.icon,
    required dynamic value,
    required this.type,
  }) : text = _format(value, type);

  static String _format(dynamic value, AttendanceInfoType type) {
    if (value == null) return '--:--';
    
    switch (type) {
      case AttendanceInfoType.clock:
        if (value is DateTime) {
          return DateFormat('hh:mm a').format(value.toLocal());
        }
        return value.toString();
      case AttendanceInfoType.calendar:
        if (value is DateTime) {
          return DateFormat('EEE, MMM d, yyyy').format(value.toLocal());
        }
        return value.toString();
      default:
        return value.toString();
    }
  }
}
