import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/utils/json_converters.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_query_options.dart';

part 'team_status_query_options_model.freezed.dart';
part 'team_status_query_options_model.g.dart';

@freezed
sealed class TeamStatusQueryOptionsModel with _$TeamStatusQueryOptionsModel {
  const factory TeamStatusQueryOptionsModel({
    @JsonKey(name: 'status_filter', includeIfNull: false)
    @AttendanceStatusNullableConverter()
    AttendanceStatus? status,
    String? order,
    int? limit,
  }) = _TeamStatusQueryOptionsModel;

  const TeamStatusQueryOptionsModel._();

  factory TeamStatusQueryOptionsModel.fromEntity(
    TeamStatusQueryOptions entity,
  ) {
    return TeamStatusQueryOptionsModel(
      status: entity.status,
      order: entity.order,
      limit: entity.limit,
    );
  }

  factory TeamStatusQueryOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusQueryOptionsModelFromJson(json);

  TeamStatusQueryOptions toEntity() => TeamStatusQueryOptions(
        status: status,
        order: order ?? 'desc',
        limit: limit,
      );
}

