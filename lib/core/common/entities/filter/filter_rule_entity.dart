import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';

class FilterRuleEntity extends Equatable {
  final JobFilterField field;
  final FilterOperator operator;
  final dynamic value;

  const FilterRuleEntity({
    required this.field,
    required this.operator,
    required this.value,
  });

  @override
  List<Object?> get props => [field, operator, value];

  FilterRuleEntity copyWith({
    JobFilterField? field,
    FilterOperator? operator,
    dynamic value,
  }) {
    return FilterRuleEntity(
      field: field ?? this.field,
      operator: operator ?? this.operator,
      value: value ?? this.value,
    );
  }
}
