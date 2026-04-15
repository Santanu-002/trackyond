import 'package:hugeicons/hugeicons.dart';

class AppIcons {
  static final AuthIcons auth = AuthIcons();
  static final AdminIcons admin = AdminIcons();
  static final StatusIcons status = StatusIcons();
  static final CommonIcons common = CommonIcons();
}

class AuthIcons {
  AuthIcons();
  final dynamic email = HugeIcons.strokeRoundedMail01;
  final dynamic password = HugeIcons.strokeRoundedLockPassword;
  final dynamic user = HugeIcons.strokeRoundedUser;
}

class AdminIcons {
  AdminIcons();
  final dynamic phone = HugeIcons.strokeRoundedSmartPhone01;
  final dynamic info = HugeIcons.strokeRoundedInformationCircle;
  final dynamic back = HugeIcons.strokeRoundedArrowLeft01;
}

class StatusIcons {
  StatusIcons();
  final dynamic error = HugeIcons.strokeRoundedAlertCircle;
  final dynamic success = HugeIcons.strokeRoundedCheckmarkCircle01;
  final dynamic info = HugeIcons.strokeRoundedInformationCircle;
}

class CommonIcons {
  CommonIcons();
  final dynamic logout = HugeIcons.strokeRoundedLogout01;
  final dynamic search = HugeIcons.strokeRoundedSearch01;
}
