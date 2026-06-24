import 'package:trackyond/core/services/sync/models/sync_query.dart';

class GetAssignedJobsQuery extends SyncQuery {
  final String? status;
  final int limit;
  final int offset;

  const GetAssignedJobsQuery({
    this.status,
    required this.limit,
    required this.offset,
  });

  @override
  List<Object?> get props => [status, limit, offset];
}
