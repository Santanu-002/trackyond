import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
sealed class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String companyId,
    required String companyName,
    required int teamSize,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  const CompanyModel._();

  CompanyEntity toEntity() =>
      CompanyEntity(uid: companyId, name: companyName, teamSize: teamSize);

  factory CompanyModel.fromEntity(CompanyEntity entity) => CompanyModel(
        companyId: entity.uid,
        companyName: entity.name,
        teamSize: entity.teamSize,
      );
}
