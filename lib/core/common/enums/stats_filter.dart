enum StatsFilter {
  today('today'),
  overall('overall');

  final String value;
  const StatsFilter(this.value);

  static StatsFilter fromString(String? value) {
    return StatsFilter.values.firstWhere(
      (e) => e.value == value,
      orElse: () => StatsFilter.today,
    );
  }
}
