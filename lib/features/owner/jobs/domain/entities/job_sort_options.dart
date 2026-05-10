import 'package:equatable/equatable.dart';

enum JobSortField {
  createdAt('createdAt'),
  jobTitle('jobTitle'),
  status('status'),
  customerName('customerName'),
  workerName('workerName'),
  assignedAt('assignedAt'),
  completedAt('completedAt'),
  startedAt('startedAt'),
  updatedAt('updatedAt');

  final String value;
  const JobSortField(this.value);
}

enum SortOrder {
  asc('asc'),
  desc('desc');

  final String value;
  const SortOrder(this.value);
}

class JobSortOptions extends Equatable {
  final JobSortField field;
  final SortOrder order;

  const JobSortOptions({
    this.field = JobSortField.createdAt,
    this.order = SortOrder.desc,
  });

  @override
  List<Object?> get props => [field, order];

  JobSortOptions copyWith({
    JobSortField? field,
    SortOrder? order,
  }) {
    return JobSortOptions(
      field: field ?? this.field,
      order: order ?? this.order,
    );
  }
}
