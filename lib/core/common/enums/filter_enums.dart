enum FilterOperator {
  equals,
  contains,
  greaterThan,
  lessThan,
  between,
  inList,
}

enum LogicalOperator {
  and('Match ALL (AND)', 'Show jobs that match every filter rule'),
  or('Match ANY (OR)', 'Show jobs that match at least one filter rule');

  final String label;
  final String description;
  const LogicalOperator(this.label, this.description);
}

enum SortOrder {
  asc('asc'),
  desc('desc');

  final String value;
  const SortOrder(this.value);

  static SortOrder fromString(String? val) {
    if (val == null) return SortOrder.desc;
    return SortOrder.values.firstWhere(
      (e) => e.value == val.toLowerCase(),
      orElse: () => SortOrder.desc,
    );
  }
}

enum JobFilterField {
  status('status'),
  worker('worker'),
  date('date');

  final String value;
  const JobFilterField(this.value);

  static JobFilterField fromString(String? val) {
    if (val == null) return JobFilterField.status;
    return JobFilterField.values.firstWhere(
      (e) => e.value == val.toLowerCase(),
      orElse: () => JobFilterField.status,
    );
  }
}
