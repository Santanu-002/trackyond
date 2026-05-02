import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceStatusTime extends StatelessWidget {
  final DateTime? time;

  const AttendanceStatusTime({super.key, this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      time != null ? DateFormat('hh:mm a').format(time!.toLocal()) : '-',
      style: context.textTheme.labelSmall?.copyWith(
        color: context.theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
