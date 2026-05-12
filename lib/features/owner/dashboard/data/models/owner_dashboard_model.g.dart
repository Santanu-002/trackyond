// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerDashboardModel _$OwnerDashboardModelFromJson(Map<String, dynamic> json) =>
    _OwnerDashboardModel(
      teamMembersStatus: (json['teamMembersStatus'] as List<dynamic>)
          .map((e) => TeamMemberStatusModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobCounts: JobCountsModel.fromJson(
        json['jobCounts'] as Map<String, dynamic>,
      ),
      recentJobs: (json['recentJobs'] as List<dynamic>)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OwnerDashboardModelToJson(
  _OwnerDashboardModel instance,
) => <String, dynamic>{
  'teamMembersStatus': instance.teamMembersStatus,
  'jobCounts': instance.jobCounts,
  'recentJobs': instance.recentJobs,
};

_JobCountsModel _$JobCountsModelFromJson(Map<String, dynamic> json) =>
    _JobCountsModel(
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      inProgress: (json['inProgress'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$JobCountsModelToJson(_JobCountsModel instance) =>
    <String, dynamic>{
      'pending': instance.pending,
      'inProgress': instance.inProgress,
      'completed': instance.completed,
      'cancelled': instance.cancelled,
    };
