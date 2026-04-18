import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/worker_profile/worker_profile.dart';

part 'worker_profile_model.freezed.dart';
part 'worker_profile_model.g.dart';

@freezed
sealed class WorkerProfileModel with _$WorkerProfileModel {
  const factory WorkerProfileModel({
    required String uid,
    required String name,
    required String phone,
    required String designation,
    String? gender,
    String? image,
  }) = _WorkerProfileModel;

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileModelFromJson(json);

  const WorkerProfileModel._();

  WorkerProfile toEntity() => WorkerProfile(
    uid: uid,
    name: name,
    phone: phone,
    designation: designation,
    gender: gender,
    image: image,
  );

  factory WorkerProfileModel.fromEntity(WorkerProfile entity) =>
      WorkerProfileModel(
        uid: entity.uid,
        name: entity.name,
        phone: entity.phone,
        designation: entity.designation,
        gender: entity.gender,
        image: entity.image,
      );
}
