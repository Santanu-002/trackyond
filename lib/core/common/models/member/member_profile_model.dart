import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';

part 'member_profile_model.freezed.dart';
part 'member_profile_model.g.dart';

@freezed
sealed class MemberProfileModel with _$MemberProfileModel {
  const factory MemberProfileModel({
    required String uid,
    required String name,
    required String phone,
    required String designation,
    String? gender,
    String? image,
  }) = _MemberProfileModel;

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileModelFromJson(json);

  const MemberProfileModel._();

  MemberProfile toEntity() => MemberProfile(
        uid: uid,
        name: name,
        phone: phone,
        designation: designation,
        gender: gender,
        image: image,
      );

  factory MemberProfileModel.fromEntity(MemberProfile entity) =>
      MemberProfileModel(
        uid: entity.uid,
        name: entity.name,
        phone: entity.phone,
        designation: entity.designation,
        gender: entity.gender,
        image: entity.image,
      );
}
