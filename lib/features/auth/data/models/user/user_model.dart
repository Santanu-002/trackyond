import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String phone,
    required UserRole role,
    required bool isNewUser,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  User toEntity() => User(uid: uid, phone: phone, role: role, isNewUser: isNewUser);

  factory UserModel.fromEntity(User entity) => UserModel(
        uid: entity.uid,
        phone: entity.phone,
        role: entity.role,
        isNewUser: entity.isNewUser,
      );
}
