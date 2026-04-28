import 'package:freezed_annotation/freezed_annotation.dart';

part 'switch_profile_model.freezed.dart';
part 'switch_profile_model.g.dart';

@freezed
sealed class SwitchProfileModel with _$SwitchProfileModel {
  const factory SwitchProfileModel({
    required String accountUid,
    required String userUid,
    required String name,
    required String designation,
    String? image,
    required SwitchProfileCompanyModel company,
    @JsonKey(name: 'isPrimary') required bool isPrimary,
  }) = _SwitchProfileModel;

  factory SwitchProfileModel.fromJson(Map<String, dynamic> json) =>
      _$SwitchProfileModelFromJson(json);
}

@freezed
sealed class SwitchProfileCompanyModel with _$SwitchProfileCompanyModel {
  const factory SwitchProfileCompanyModel({
    required String id,
    required String name,
  }) = _SwitchProfileCompanyModel;

  factory SwitchProfileCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$SwitchProfileCompanyModelFromJson(json);
}
