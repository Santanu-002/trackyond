import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_profile.freezed.dart';
part 'owner_profile.g.dart';


@freezed
sealed class OwnerProfile with _$OwnerProfile {
  const factory OwnerProfile({
    required String uid,
    required String phone,
    required bool isNewUser,
  }) = _OwnerProfile;

  factory OwnerProfile.fromJson(Map<String, dynamic> json) =>
      _$OwnerProfileFromJson(json);


}