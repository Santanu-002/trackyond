class NotificationFilterOptions {
  final int limit;
  final int offset;
  final bool? isRead;
  final bool isNewestFirst;

  const NotificationFilterOptions({
    this.limit = 50,
    this.offset = 0,
    this.isRead,
    this.isNewestFirst = true,
  });

  NotificationFilterOptions copyWith({
    int? limit,
    int? offset,
    bool? isRead,
    bool? isNewestFirst,
  }) {
    return NotificationFilterOptions(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isRead: isRead ?? this.isRead,
      isNewestFirst: isNewestFirst ?? this.isNewestFirst,
    );
  }
}
