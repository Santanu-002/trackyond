import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/company_entity.dart';

part 'company_response_model.freezed.dart';

@freezed
sealed class CompanyResponseModel with _$CompanyResponseModel {
  const factory CompanyResponseModel({
    required String companyId,
    required String companyName,
    required String createdAt,
  }) = _CompanyResponseModel;

  const CompanyResponseModel._();

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      companyId: json['companyId'] as String,
      companyName: json['companyName'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  CompanyEntity toEntity() => CompanyEntity(
        companyId: companyId,
        companyName: companyName,
        createdAt: DateTime.parse(createdAt),
      );
}
