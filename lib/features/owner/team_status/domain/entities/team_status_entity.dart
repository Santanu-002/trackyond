import 'package:trackyond/features/owner/team_status/domain/entities/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_stats_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_options_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_pagination_entity.dart';

class TeamStatusEntity {
  final List<TeamMemberStatusEntity> members;
  final TeamStatusStatsEntity stats;
  final TeamStatusOptionsEntity options;
  final TeamStatusPaginationEntity pagination;

  const TeamStatusEntity({
    required this.members,
    required this.stats,
    required this.options,
    required this.pagination,
  });
}
