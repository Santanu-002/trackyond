import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/services/database/tables/member_table.dart';

part 'member_profile_model.freezed.dart';
part 'member_profile_model.g.dart';

Gender? _genderFromJson(String? value) => value != null ? Gender.fromString(value) : null;
String? _genderToJson(Gender? gender) => gender?.value;

@freezed
sealed class MemberProfileModel with _$MemberProfileModel implements MemberProfile {
  const factory MemberProfileModel({
    required String uid,
    required String userUid,
    required String name,
    required String phone,
    required String designation,
    @JsonKey(fromJson: _genderFromJson, toJson: _genderToJson) Gender? gender,
    String? image,
    String? companyUid,
    String? createdBy,
  }) = _MemberProfileModel;

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileModelFromJson(json);

  const MemberProfileModel._();

  Map<String, dynamic> toDbMap() {
    return {
      MemberTable.columnNames.uid: uid,
      MemberTable.columnNames.userUid: userUid,
      MemberTable.columnNames.name: name,
      MemberTable.columnNames.phone: phone,
      MemberTable.columnNames.designation: designation,
      MemberTable.columnNames.gender: gender?.value,
      MemberTable.columnNames.image: image,
      MemberTable.columnNames.companyUid: companyUid,
      MemberTable.columnNames.createdBy: createdBy,
    };
  }

  factory MemberProfileModel.fromDbMap(Map<String, dynamic> map) {
    return MemberProfileModel(
      uid: map[MemberTable.columnNames.uid] as String,
      userUid: map[MemberTable.columnNames.userUid] as String,
      name: map[MemberTable.columnNames.name] as String,
      phone: map[MemberTable.columnNames.phone] as String,
      designation: map[MemberTable.columnNames.designation] as String,
      gender: map[MemberTable.columnNames.gender] != null
          ? Gender.fromString(map[MemberTable.columnNames.gender] as String)
          : null,
      image: map[MemberTable.columnNames.image] as String?,
      companyUid: map[MemberTable.columnNames.companyUid] as String?,
      createdBy: map[MemberTable.columnNames.createdBy] as String?,
    );
  }

  factory MemberProfileModel.fromEntity(MemberProfile entity) =>
      MemberProfileModel(
        uid: entity.uid,
        userUid: entity.userUid,
        name: entity.name,
        phone: entity.phone,
        designation: entity.designation,
        gender: entity.gender,
        image: entity.image,
        companyUid: entity.companyUid,
        createdBy: entity.createdBy,
      );
}
