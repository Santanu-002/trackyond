import 'package:trackyond/core/services/sync/models/sync_query.dart';

/// Cache key for the initial chat messages sync.
/// Intentionally keyed on [jobId] only — limit/offset are NOT included because
/// we want all pagination pages to share the same cache entry so only ONE
/// background sync fires per [cacheDuration], regardless of how many pages
/// the user has scrolled through.
class GetChatMessagesQuery extends SyncQuery {
  final String jobId;

  const GetChatMessagesQuery({required this.jobId});

  @override
  List<Object?> get props => [jobId];
}
