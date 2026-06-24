enum SyncPriority {
  low(0),
  normal(1),
  high(2);

  final int value;
  const SyncPriority(this.value);

  static SyncPriority fromInt(int val) {
    switch (val) {
      case 0:
        return SyncPriority.low;
      case 2:
        return SyncPriority.high;
      case 1:
      default:
        return SyncPriority.normal;
    }
  }
}
