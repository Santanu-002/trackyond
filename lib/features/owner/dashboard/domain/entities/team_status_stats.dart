import 'package:equatable/equatable.dart';

class TeamStatusStats extends Equatable {
  final int total;
  final int working;
  final int notStarted;

  const TeamStatusStats({
    required this.total,
    required this.working,
    required this.notStarted,
  });

  @override
  List<Object?> get props => [total, working, notStarted];
}
