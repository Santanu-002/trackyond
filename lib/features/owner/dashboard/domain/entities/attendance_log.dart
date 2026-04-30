import 'package:equatable/equatable.dart';

class AttendanceLog extends Equatable {
  final String logUid;
  final String accountUid;
  final String userUid;
  final String name;
  final String status;
  final DateTime startAt;
  final DateTime? endAt;
  final String? startLocation;
  final String? endLocation;

  const AttendanceLog({
    required this.logUid,
    required this.accountUid,
    required this.userUid,
    required this.name,
    required this.status,
    required this.startAt,
    this.endAt,
    this.startLocation,
    this.endLocation,
  });

  DateTime get date => DateTime(startAt.year, startAt.month, startAt.day);
  DateTime get checkIn => startAt;
  DateTime? get checkOut => endAt;
  String? get location => startLocation;

  String get workHours {
    if (endAt == null) return '--:--';
    final duration = endAt!.difference(startAt);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}h';
  }

  @override
  List<Object?> get props => [
        logUid,
        accountUid,
        userUid,
        name,
        status,
        startAt,
        endAt,
        startLocation,
        endLocation,
      ];
}


