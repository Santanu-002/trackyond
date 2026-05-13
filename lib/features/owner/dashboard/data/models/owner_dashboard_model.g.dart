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
      jobCounts: JobSummaryStatsModel.fromJson(
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
