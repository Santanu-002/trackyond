import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:trackyond/features/auth/presentation/bindings/send_otp_binding.dart';
import 'package:trackyond/features/auth/presentation/bindings/verify_otp_binding.dart';
import 'package:trackyond/features/auth/presentation/screens/auth_gate_page.dart';
import 'package:trackyond/features/auth/presentation/screens/choose_role_page.dart';
import 'package:trackyond/features/auth/presentation/screens/send_otp_page.dart';
import 'package:trackyond/features/auth/presentation/screens/verify_otp_page.dart';
import 'package:trackyond/features/owner/dashboard/presentation/bindings/owner_dashboard_binding.dart';
import 'package:trackyond/features/owner/dashboard/presentation/screens/owner_dashboard_page.dart';
import 'package:trackyond/features/owner/setup_company/presentation/bindings/setup_company_binding.dart';
import 'package:trackyond/features/owner/setup_company/presentation/screens/setup_company_page.dart';
import 'package:trackyond/features/owner/setup_company/presentation/screens/choose_team_size_page.dart';
import 'package:trackyond/features/worker/presentation/bindings/worker_dashboard_binding.dart';
import 'package:trackyond/features/worker/presentation/screens/worker_dashboard_page.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage> pages = [
    ..._commonPages,
    ..._authPages,
    ..._ownerPages,
    ..._workerPages,
  ];

  static final List<GetPage> _commonPages = [
    GetPage(
      name: AppRoutes.common.auth.splash,
      binding: AuthBindings(),
      page: () => const AuthGatePage(),
    ),
  ];

  static final List<GetPage> _authPages = [
    GetPage(
      name: AppRoutes.common.auth.chooseRole,
      binding: AuthBindings(),
      page: () => const ChooseRolePage(),
    ),
    GetPage(
      name: AppRoutes.common.auth.sendOtp,
      bindings: [AuthBindings(), SendOtpBinding()],
      page: () => const SendOtpPage(),
    ),
    GetPage(
      name: AppRoutes.common.auth.verifyOtp,
      bindings: [AuthBindings(), VerifyOtpBinding()],
      page: () => const VerifyOtpPage(),
    ),
  ];

  static final List<GetPage> _ownerPages = [
    GetPage(
      name: AppRoutes.owner.dashboard,
      binding: OwnerDashboardBinding(),
      page: () => const OwnerDashboardPage(),
    ),
    GetPage(
      name: AppRoutes.owner.setupCompany,
      page: () => const SetupCompanyPage(),
      binding: SetupCompanyBinding(),
    ),
    GetPage(
      name: AppRoutes.owner.chooseTeamSize,
      page: () => const ChooseTeamSizePage(),
      binding: SetupCompanyBinding(),
    ),
  ];

  static final List<GetPage> _workerPages = [
    GetPage(
      name: AppRoutes.worker.dashboard,
      binding: WorkerDashboardBinding(),
      page: () => const WorkerDashboardPage(),
    ),
  ];
}
