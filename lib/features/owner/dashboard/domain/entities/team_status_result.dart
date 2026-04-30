import 'package:equatable/equatable.dart';

import 'team_member_status.dart';
import 'team_status_stats.dart';

class TeamStatusResult extends Equatable {
  final TeamStatusStats stats;
  final List<TeamMemberStatus> members;

  const TeamStatusResult({
    required this.stats,
    required this.members,
  });

  @override
  List<Object?> get props => [stats, members];
}
