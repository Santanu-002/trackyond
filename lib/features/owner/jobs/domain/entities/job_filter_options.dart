import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/entities/filter_group_entity.dart';

enum JobSearchField {
  all('all'),
  title('title'),
  customer('customer'),
  address('address'),
  worker('worker');

  final String value;
  const JobSearchField(this.value);
}

class JobFilterOptions extends Equatable {
  final String? search;
  final JobSearchField searchBy;
  final FilterGroupEntity advancedFilter;

  const JobFilterOptions({
    this.search,
    this.searchBy = JobSearchField.all,
    this.advancedFilter = const FilterGroupEntity(),
  });

  @override
  List<Object?> get props => [
        search,
        searchBy,
        advancedFilter,
      ];

  JobFilterOptions copyWith({
    String? search,
    JobSearchField? searchBy,
    FilterGroupEntity? advancedFilter,
  }) {
    return JobFilterOptions(
      search: search ?? this.search,
      searchBy: searchBy ?? this.searchBy,
      advancedFilter: advancedFilter ?? this.advancedFilter,
    );
  }

  bool get isEmpty =>
      (search == null || search!.isEmpty) &&
      advancedFilter.isEmpty;
}
