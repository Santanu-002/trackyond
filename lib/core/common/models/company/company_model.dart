import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
sealed class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String companyId,
    required String companyName,
    required String userPhoneNo,
    required int teamSize,
    required String createdAt,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  const CompanyModel._();

  CompanyEntity toEntity() => CompanyEntity(
        id: companyId,
        name: companyName,
        createdAt: DateTime.parse(createdAt),
      );
}
