import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/owner_profile/owner_profile.dart';

part 'owner_profile_model.freezed.dart';
part 'owner_profile_model.g.dart';

@freezed
sealed class OwnerProfileModel with _$OwnerProfileModel {
  const factory OwnerProfileModel({
    required String uid,
    required String phone,
    required bool isNewUser,
  }) = _OwnerProfileModel;

  factory OwnerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerProfileModelFromJson(json);

  const OwnerProfileModel._();

  OwnerProfile toEntity() =>
      OwnerProfile(uid: uid, phone: phone, isNewUser: isNewUser);

  factory OwnerProfileModel.fromEntity(OwnerProfile entity) =>
      OwnerProfileModel(
        uid: entity.uid,
        phone: entity.phone,
        isNewUser: entity.isNewUser,
      );
}
