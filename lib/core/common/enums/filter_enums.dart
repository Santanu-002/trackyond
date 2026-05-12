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
