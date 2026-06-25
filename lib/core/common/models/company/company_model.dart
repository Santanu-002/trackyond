import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
sealed class CompanyModel with _$CompanyModel implements CompanyEntity {
  const factory CompanyModel({
    @JsonKey(name: 'companyId') required String uid,
    @JsonKey(name: 'companyName') required String name,
    required int teamSize,
    required String ownerUid,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  const CompanyModel._();

  factory CompanyModel.fromEntity(CompanyEntity entity) => CompanyModel(
        uid: entity.uid,
        name: entity.name,
        teamSize: entity.teamSize,
        ownerUid: entity.ownerUid,
      );
}
