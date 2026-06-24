sealed class SyncResult {
  const SyncResult();
}

class SyncSuccess extends SyncResult {
  const SyncSuccess();
}

class SyncRetry extends SyncResult {
  final String reason;
  const SyncRetry(this.reason);
}

class SyncDiscard extends SyncResult {
  final String reason;
  const SyncDiscard(this.reason);
}
