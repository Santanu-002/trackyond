import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/setup_company_result_entity.dart';

part 'company_response_model.freezed.dart';

@freezed
sealed class CompanyResponseModel with _$CompanyResponseModel {
  const factory CompanyResponseModel({
    required MemberProfileModel memberProfile,
    required CompanyModel company,
  }) = _CompanyResponseModel;

  const CompanyResponseModel._();

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      memberProfile: MemberProfileModel.fromJson(
        json['ownerProfile'] as Map<String, dynamic>,
      ),
      company: CompanyModel.fromJson(
        json['company'] as Map<String, dynamic>,
      ),
    );
  }

  SetupCompanyResultEntity toEntity() => SetupCompanyResultEntity(
        company: company.toEntity(),
        memberProfile: memberProfile.toEntity(),
      );
}

