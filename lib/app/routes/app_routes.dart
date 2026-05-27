class AppRoutes {
  const AppRoutes._();

  static const common = _CommonRoutes();
  static const owner = _OwnerRoutes();
  static const worker = _WorkerRoutes();
}

class _OwnerRoutes {
  const _OwnerRoutes();

  String get _base => '/owner';
  String get dashboard => '$_base/dashboard';
  String get setupCompany => '$_base/setup-company';
  String get chooseTeamSize => '$_base/choose-team-size';
  String get addTeamMember => '$_base/add-team-member';
  String get addMemberDetails => '$_base/add-member-details';
  String get team => '$_base/team';
  String get teamMemberProfile => '$_base/team-member-profile';
  String get jobs => '$_base/jobs';
  String get createJob => '$_base/create-job';
  String get jobDetails => '$_base/job-details';
}

class _WorkerRoutes {
  const _WorkerRoutes();

  String get _base => '/worker';
  String get dashboard => '$_base/dashboard';
  String get profile => '$_base/profile';
}

class _AuthRoutes {
  const _AuthRoutes();

  String get _base => '/auth';

  String get splash => '$_base/splash';
  String get chooseRole => '$_base/choose-role';
  String get sendOtp => '$_base/send-otp';
  String get verifyOtp => '$_base/verify-otp';
}

class _CommonRoutes {
  const _CommonRoutes();

  _AuthRoutes get auth => const _AuthRoutes();
  
  String get notifications => '/notifications';
  String get notificationDetails => '/notification-details';
  String get jobChat => '/job-chat';
  String get mediaPreview => '/media-preview';
}
