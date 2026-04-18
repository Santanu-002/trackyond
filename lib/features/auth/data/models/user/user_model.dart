import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    required UserRole role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  User toEntity() => User(id: id, phone: phone, role: role);

  factory UserModel.fromEntity(User entity) =>
      UserModel(id: entity.id, phone: entity.phone, role: entity.role);
}
