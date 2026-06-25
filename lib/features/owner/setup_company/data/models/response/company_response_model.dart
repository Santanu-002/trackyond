import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/setup_company_result_entity.dart';

part 'company_response_model.freezed.dart';
part 'company_response_model.g.dart';

@freezed
sealed class CompanyResponseModel with _$CompanyResponseModel implements SetupCompanyResultEntity {
  const factory CompanyResponseModel({
    @JsonKey(name: 'ownerProfile') required MemberProfileModel memberProfile,
    required CompanyModel company,
  }) = _CompanyResponseModel;

  const CompanyResponseModel._();

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyResponseModelFromJson(json);

  @override
  List<Object?> get props => [company, memberProfile];

  @override
  bool? get stringify => true;
}
