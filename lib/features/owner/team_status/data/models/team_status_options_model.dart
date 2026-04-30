import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_options_entity.dart';

part 'team_status_options_model.freezed.dart';
part 'team_status_options_model.g.dart';

@freezed
sealed class TeamStatusOptionsModel with _$TeamStatusOptionsModel {
  const factory TeamStatusOptionsModel({
    String? statusFilter,
    String? order,
  }) = _TeamStatusOptionsModel;

  const TeamStatusOptionsModel._();

  factory TeamStatusOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusOptionsModelFromJson(json);

  TeamStatusOptionsEntity toEntity() => TeamStatusOptionsEntity(
        statusFilter: statusFilter,
        order: order,
      );
}
