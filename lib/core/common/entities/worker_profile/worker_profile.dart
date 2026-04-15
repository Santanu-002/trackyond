import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile.freezed.dart';
part 'worker_profile.g.dart';

@freezed
sealed class WorkerProfile with _$WorkerProfile {
  const factory WorkerProfile({
    required String uid,
    required String name,
    required String phone,
    required String designation,
    String? gender,
    String? image,
  }) = _WorkerProfile;

  factory WorkerProfile.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileFromJson(json);

}