import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String phone,
    @JsonKey(fromJson: UserRole.fromString) required UserRole role,
    required bool isNewUser,
    String? primaryProfileUid,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  User toEntity() => User(
        uid: uid,
        phone: phone,
        role: role,
        isNewUser: isNewUser,
        primaryProfileUid: primaryProfileUid,
      );

  factory UserModel.fromEntity(User entity) => UserModel(
        uid: entity.uid,
        phone: entity.phone,
        role: entity.role,
        isNewUser: entity.isNewUser,
        primaryProfileUid: entity.primaryProfileUid,
      );
}
