import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._();

  static const auth = _AuthIcons();
  static const status = _StatusIcons();
  static const common = _CommonIcons();
  static const dashboard = _DashboardIcons();
  static const jobs = _JobsIcons();
  static const profile = _ProfileIcons();
  static const setup = _SetupIcons();
}

class _AuthIcons {
  const _AuthIcons();

  IconData get email => Icons.email_outlined;

  IconData get password => Icons.lock_outline_rounded;

  IconData get user => Icons.person_outline_rounded;

  IconData get phone => Icons.phone_android_rounded;

  IconData get phoneOutlined => Icons.phone_outlined;

  IconData get role => Icons.admin_panel_settings_rounded;
}


class _StatusIcons {
  const _StatusIcons();

  IconData get error => Icons.error_outline_rounded;

  IconData get success => Icons.check_circle_outline_rounded;

  IconData get info => Icons.info_outline_rounded;

  IconData get warn => Icons.warning_amber_rounded;

  IconData get verified => Icons.verified_user_rounded;
}

class _CommonIcons {
  const _CommonIcons();

  IconData get back => Icons.arrow_back_ios_new_rounded;

  IconData get logout => Icons.logout_rounded;

  IconData get search => Icons.search_rounded;

  IconData get play => Icons.play_arrow_rounded;

  IconData get stop => Icons.stop_rounded;

  IconData get add => Icons.add_rounded;

  IconData get close => Icons.close_rounded;

  IconData get notifications => Icons.notifications_none_rounded;

  IconData get camera => Icons.camera_alt_rounded;

  IconData get gallery => Icons.photo_library_rounded;

  IconData get delete => Icons.delete_rounded;

  IconData get business => Icons.business_rounded;

  IconData get team => Icons.groups_rounded;

  IconData get person => Icons.person_rounded;

  IconData get menu => Icons.menu_rounded;
}

class _DashboardIcons {
  const _DashboardIcons();

  IconData get location => Icons.location_on_outlined;

  IconData get clock => Icons.access_time_rounded;

  IconData get timer => Icons.hourglass_empty_rounded;

  IconData get calendar => Icons.calendar_today_rounded;

  IconData get recentHistory => Icons.history_toggle_off_rounded;

  IconData get active => Icons.bolt_rounded;

  IconData get completed => Icons.task_alt_rounded;

  IconData get insights => Icons.insights_rounded;

  IconData get wallet => Icons.account_balance_wallet_rounded;

  IconData get settings => Icons.settings_rounded;

  IconData get dashboard => Icons.dashboard_rounded;

  IconData get assignment => Icons.assignment_rounded;
}

class _JobsIcons {
  const _JobsIcons();

  IconData get work => Icons.work_outline_rounded;

  IconData get chevronRight => Icons.chevron_right_rounded;
}

class _ProfileIcons {
  const _ProfileIcons();

  IconData get badge => Icons.badge_outlined;
}

class _SetupIcons {
  const _SetupIcons();

  IconData get gift => Icons.card_giftcard_rounded;

  IconData get manageAccounts => Icons.manage_accounts_rounded;
}
