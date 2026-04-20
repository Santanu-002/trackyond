import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/setup_company_result_entity.dart';

part 'company_response_model.freezed.dart';

@freezed
sealed class CompanyResponseModel with _$CompanyResponseModel {
  const factory CompanyResponseModel({
    required MemberProfileModel memberProfile,
    required CompanyDetailModel company,
  }) = _CompanyResponseModel;

  const CompanyResponseModel._();

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      memberProfile: MemberProfileModel.fromJson(
        json['ownerProfile'] as Map<String, dynamic>,
      ),
      company: CompanyDetailModel.fromJson(
        json['company'] as Map<String, dynamic>,
      ),
    );
  }

  SetupCompanyResultEntity toEntity() => SetupCompanyResultEntity(
        company: company.toEntity(),
        memberProfile: memberProfile.toEntity(),
      );
}

@freezed
sealed class CompanyDetailModel with _$CompanyDetailModel {
  const factory CompanyDetailModel({
    required String companyId,
    required String companyName,
    required String userPhoneNo,
    required int teamSize,
    required String createdAt,
  }) = _CompanyDetailModel;

  const CompanyDetailModel._();

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailModel(
      companyId: json['companyId'] as String,
      companyName: json['companyName'] as String,
      userPhoneNo: json['userPhoneNo'] as String,
      teamSize: json['teamSize'] as int,
      createdAt: json['createdAt'] as String,
    );
  }

  CompanyEntity toEntity() => CompanyEntity(
        id: companyId,
        name: companyName,
        createdAt: DateTime.parse(createdAt),
      );
}
