import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';

part 'profile_response_model.freezed.dart';
part 'profile_response_model.g.dart';

@freezed
sealed class ProfileResponseModel with _$ProfileResponseModel {
  const factory ProfileResponseModel({
    MemberProfileModel? profile,
    CompanyModel? company,
  }) = _ProfileResponseModel;

  const ProfileResponseModel._();

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);
}
