class AppRoutes {
  const AppRoutes._();

  static const common = _CommonRoutes();
  static const owner = _OwnerRoutes();
  static const worker = _WorkerRoutes();
}

class _OwnerRoutes {
  const _OwnerRoutes();

  static const _prefix = '/admin';

  _AuthRoutes get auth => const _AuthRoutes(prefix: _prefix);
}

class _WorkerRoutes {
  const _WorkerRoutes();

  _AuthRoutes get auth => const _AuthRoutes();
}

class _AuthRoutes {
  final String prefix;

  const _AuthRoutes({this.prefix = ''});

  String get _base => '$prefix/auth';

  String get login => '$_base/send-otp';

  String get register => '$_base/verify-otp';
}

class _CommonRoutes {
  const _CommonRoutes();

  String get splash => '/splash';
  String get chooseRole => '/choose-role';
}