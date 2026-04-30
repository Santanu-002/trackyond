import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_pagination_entity.dart';

part 'team_status_pagination_model.freezed.dart';
part 'team_status_pagination_model.g.dart';

@freezed
sealed class TeamStatusPaginationModel with _$TeamStatusPaginationModel {
  const factory TeamStatusPaginationModel({
    required int limit,
    required int totalItems,
  }) = _TeamStatusPaginationModel;

  const TeamStatusPaginationModel._();

  factory TeamStatusPaginationModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusPaginationModelFromJson(json);

  TeamStatusPaginationEntity toEntity() => TeamStatusPaginationEntity(
        limit: limit,
        totalItems: totalItems,
      );
}
