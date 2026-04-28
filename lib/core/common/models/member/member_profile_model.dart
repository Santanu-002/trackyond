import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';

part 'member_profile_model.freezed.dart';
part 'member_profile_model.g.dart';

@freezed
sealed class MemberProfileModel with _$MemberProfileModel {
  const factory MemberProfileModel({
    required String accountUid,
    required String userUid,
    required String name,
    required String phone,
    required String designation,
    String? gender,
    String? image,
    String? companyUid,
    String? createdBy,
  }) = _MemberProfileModel;

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileModelFromJson(json);

  const MemberProfileModel._();

  MemberProfile toEntity() => MemberProfile(
        accountUid: accountUid,
        userUid: userUid,
        name: name,
        phone: phone,
        designation: designation,
        gender: gender != null ? Gender.fromString(gender!) : null,
        image: image,
        companyUid: companyUid,
        createdBy: createdBy,
      );

  factory MemberProfileModel.fromEntity(MemberProfile entity) =>
      MemberProfileModel(
        accountUid: entity.accountUid,
        userUid: entity.userUid,
        name: entity.name,
        phone: entity.phone,
        designation: entity.designation,
        gender: entity.gender?.value,
        image: entity.image,
        companyUid: entity.companyUid,
        createdBy: entity.createdBy,
      );
}
