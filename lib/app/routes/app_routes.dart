class AppRoutes {
  const AppRoutes._();

  static const common = _CommonRoutes();
  static const owner = _OwnerRoutes();
  static const worker = _WorkerRoutes();
}

class _OwnerRoutes {
  const _OwnerRoutes();

  // static const _prefix = '/admin';
}

class _WorkerRoutes {
  const _WorkerRoutes();
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
}
