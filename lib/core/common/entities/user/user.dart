import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required String id,
    required String phone,
    required UserRole role,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}