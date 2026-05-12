import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/entities/filter_rule_entity.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';

class FilterGroupEntity extends Equatable {
  final LogicalOperator logicalOperator;
  final List<FilterRuleEntity> rules;
  final List<LogicalOperator> operators; // Operators between rules
  final List<FilterGroupEntity> groups;

  const FilterGroupEntity({
    this.logicalOperator = LogicalOperator.or,
    this.rules = const [],
    this.operators = const [],
    this.groups = const [],
  });

  @override
  List<Object?> get props => [logicalOperator, rules, operators, groups];

  FilterGroupEntity copyWith({
    LogicalOperator? logicalOperator,
    List<FilterRuleEntity>? rules,
    List<LogicalOperator>? operators,
    List<FilterGroupEntity>? groups,
  }) {
    return FilterGroupEntity(
      logicalOperator: logicalOperator ?? this.logicalOperator,
      rules: rules ?? this.rules,
      operators: operators ?? this.operators,
      groups: groups ?? this.groups,
    );
  }

  bool get isEmpty => rules.isEmpty && groups.isEmpty;
}
