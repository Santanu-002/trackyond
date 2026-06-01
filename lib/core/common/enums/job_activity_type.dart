import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';

enum JobActivityType {
  startedJob('startedJob'),
  completedJob('completedJob'),
  reachedLocation('reachedLocation'),
  takeBreak('takeBreak'),
  breakOut('breakOut'),
  sendLocation('sendLocation'),
  askLocation('askLocation'),
  askStatus('askStatus'),
  askStatusProofs('askStatusProofs'),
  sendStatus('sendStatus'),
  cancelJob('cancelJob'),
  reopenJob('reopenJob'),
  jobCreated('jobCreated'),
  unknown('unknown');

  final String value;
  const JobActivityType(this.value);

  static JobActivityType fromString(String? val) {
    if (val == null) return JobActivityType.unknown;
    return switch (val.trim()) {
      'startedJob' || 'started_job' => JobActivityType.startedJob,
      'completedJob' || 'completed_job' => JobActivityType.completedJob,
      'reachedLocation' || 'reached_location' => JobActivityType.reachedLocation,
      'takeBreak' || 'take_break' => JobActivityType.takeBreak,
      'breakOut' || 'break_out' => JobActivityType.breakOut,
      'sendLocation' || 'send_location' => JobActivityType.sendLocation,
      'askLocation' || 'ask_location' => JobActivityType.askLocation,
      'askStatus' || 'ask_status' => JobActivityType.askStatus,
      'askStatusProofs' || 'ask_status_proofs' => JobActivityType.askStatusProofs,
      'sendStatus' || 'send_status' => JobActivityType.sendStatus,
      'cancelJob' || 'cancel_job' => JobActivityType.cancelJob,
      'reopenJob' || 'reopen_job' => JobActivityType.reopenJob,
      'jobCreated' || 'job_created' => JobActivityType.jobCreated,
      _ => JobActivityType.unknown,
    };
  }

  String toJson() => value;

  String get title {
    return switch (this) {
      JobActivityType.jobCreated => AppStrings.jobChat.activityJobAssigned,
      JobActivityType.reachedLocation => AppStrings.jobChat.activityReachedSite,
      JobActivityType.startedJob => AppStrings.jobChat.activityJobStarted,
      JobActivityType.completedJob => AppStrings.jobChat.activityJobCompleted,
      JobActivityType.takeBreak => AppStrings.jobChat.activityOnBreak,
      JobActivityType.breakOut => AppStrings.jobChat.activityBreakEnded,
      JobActivityType.sendLocation => AppStrings.jobChat.activityLocationShared,
      JobActivityType.askLocation => AppStrings.jobChat.activityLocationRequested,
      JobActivityType.askStatus => AppStrings.jobChat.activityStatusRequested,
      JobActivityType.askStatusProofs => AppStrings.jobChat.activityStatusProofsRequested,
      JobActivityType.cancelJob => AppStrings.jobChat.activityJobCancelled,
      JobActivityType.reopenJob => AppStrings.jobChat.activityJobReopened,
      _ => AppStrings.jobChat.activityUpdate,
    };
  }

  IconData get icon {
    return switch (this) {
      JobActivityType.jobCreated => AppIcons.jobs.work,
      JobActivityType.reachedLocation => AppIcons.jobs.checkIn,
      JobActivityType.startedJob => AppIcons.common.play,
      JobActivityType.completedJob => AppIcons.status.success,
      JobActivityType.takeBreak => AppIcons.jobs.coffee,
      JobActivityType.breakOut => AppIcons.common.play,
      JobActivityType.sendLocation => AppIcons.jobs.myLocation,
      JobActivityType.askLocation => AppIcons.jobs.locationSearching,
      JobActivityType.askStatus => AppIcons.jobs.statusQuestion,
      JobActivityType.askStatusProofs => AppIcons.jobs.cameraOutlined,
      JobActivityType.cancelJob => AppIcons.dashboard.cancelled,
      JobActivityType.reopenJob => AppIcons.common.refresh,
      _ => Icons.info_outline,
    };
  }
}
