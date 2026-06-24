import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/sync/models/sync_query.dart';

abstract class BaseSyncRepository {
  static final Map<SyncQuery, DateTime> _lastSyncTimes = {};
  static final Set<SyncQuery> _activeSyncs = {};

  const BaseSyncRepository();

  /// A helper method to perform a background sync of data.
  /// 1. Fetches local data and returns it immediately to the caller.
  /// 2. Performs a remote fetch in the background (asynchronously without waiting).
  /// 3. Updates the local database when remote completes.
  /// Any database updates will automatically notify the event bus, which updates the UI.
  /// 
  /// Leverages [query] to deduplicate concurrent requests and skip fetches
  /// if the data was synced recently (within [cacheDuration]).
  Future<Either<AppFailure, LocalType>> syncData<LocalType, RemoteType>({
    required SyncQuery query,
    required Future<LocalType> Function() fetchLocal,
    required Future<RemoteType> Function() fetchRemote,
    required Future<void> Function(RemoteType remoteData) updateLocal,
    Duration cacheDuration = const Duration(minutes: 5),
    bool forceRefresh = false,
    void Function(Object error)? onRemoteError,
  }) async {
    // 1. Fetch from local database
    try {
      final localData = await fetchLocal();
      
      // 2. Check if we need to sync from remote
      final now = DateTime.now();
      final lastSync = _lastSyncTimes[query];
      final isStale = lastSync == null || now.difference(lastSync) > cacheDuration;
      final isSyncing = _activeSyncs.contains(query);

      if ((isStale || forceRefresh) && !isSyncing) {
        _runBackgroundSync(query, fetchRemote, updateLocal, onRemoteError);
      }

      return right(localData);
    } catch (e) {
      // If local fetch fails, attempt remote fetch immediately
      try {
        final remoteData = await fetchRemote();
        await updateLocal(remoteData);
        _lastSyncTimes[query] = DateTime.now();
        final localData = await fetchLocal();
        return right(localData);
      } catch (remoteErr) {
        return left(CacheFailure(e.toString()));
      }
    }
  }

  void _runBackgroundSync<RemoteType>(
    SyncQuery query,
    Future<RemoteType> Function() fetchRemote,
    Future<void> Function(RemoteType remoteData) updateLocal,
    void Function(Object error)? onRemoteError,
  ) async {
    _activeSyncs.add(query);
    try {
      final remoteData = await fetchRemote();
      await updateLocal(remoteData);
      _lastSyncTimes[query] = DateTime.now();
    } catch (e) {
      if (onRemoteError != null) {
        onRemoteError(e);
      }
    } finally {
      _activeSyncs.remove(query);
    }
  }
}
