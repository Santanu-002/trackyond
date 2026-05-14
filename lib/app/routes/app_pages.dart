import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:trackyond/features/auth/presentation/bindings/send_otp_binding.dart';
import 'package:trackyond/features/auth/presentation/bindings/verify_otp_binding.dart';
import 'package:trackyond/features/auth/presentation/screens/auth_gate_page.dart';
import 'package:trackyond/features/auth/presentation/screens/choose_role_page.dart';
import 'package:trackyond/features/auth/presentation/screens/send_otp_page.dart';
import 'package:trackyond/features/auth/presentation/screens/verify_otp_page.dart';
import 'package:trackyond/features/notification/presentation/bindings/notification_binding.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/bindings/add_team_member_binding.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/screens/add_member_details_page.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/screens/add_team_member_page.dart';
import 'package:trackyond/features/owner/dashboard/presentation/bindings/owner_dashboard_binding.dart';
import 'package:trackyond/features/owner/dashboard/presentation/screens/owner_dashboard_page.dart';
import 'package:trackyond/features/owner/jobs/presentation/bindings/create_job_binding.dart';
import 'package:trackyond/features/owner/jobs/presentation/bindings/job_details_binding.dart';
import 'package:trackyond/features/owner/jobs/presentation/bindings/jobs_binding.dart';
import 'package:trackyond/features/owner/jobs/presentation/screens/create_job_page.dart';
import 'package:trackyond/features/owner/jobs/presentation/screens/job_details_page.dart';
import 'package:trackyond/features/owner/jobs/presentation/screens/jobs_page.dart';
import 'package:trackyond/features/owner/settings/presentation/bindings/owner_settings_binding.dart';
import 'package:trackyond/features/owner/setup_company/presentation/bindings/setup_company_binding.dart';
import 'package:trackyond/features/owner/setup_company/presentation/screens/choose_team_size_page.dart';
import 'package:trackyond/features/owner/setup_company/presentation/screens/setup_company_page.dart';
import 'package:trackyond/features/owner/team_status/presentation/bindings/team_member_profile_binding.dart';
import 'package:trackyond/features/owner/team_status/presentation/bindings/team_status_binding.dart';
import 'package:trackyond/features/owner/team_status/presentation/screens/team_member_profile_page.dart';
import 'package:trackyond/features/owner/team_status/presentation/screens/team_status_page.dart';
import 'package:trackyond/features/worker/attendance/presentation/bindings/attendance_binding.dart';
import 'package:trackyond/features/worker/dashboard/presentation/bindings/worker_dashboard_binding.dart';
import 'package:trackyond/features/worker/dashboard/presentation/screens/worker_dashboard_page.dart';
import 'package:trackyond/features/worker/profile/presentation/bindings/worker_profile_binding.dart';
import 'package:trackyond/features/worker/profile/presentation/screens/worker_profile_page.dart';
import 'package:trackyond/features/worker/settings/presentation/bindings/worker_settings_binding.dart';

class AppPages {
  const AppPages._();

  static List<GetPage> get pages => [
    ..._authPages,
    ..._ownerPages,
    ..._workerPages,
  ];

  static List<GetPage> get _authPages => [
    GetPage(
      name: AppRoutes.common.auth.splash,
      binding: AuthBindings(),
      page: () => const AuthGatePage(),
    ),
    GetPage(
      name: AppRoutes.common.auth.chooseRole,
      binding: AuthBindings(),
      page: () => const ChooseRolePage(),
    ),
    GetPage(
      name: AppRoutes.common.auth.sendOtp,
      binding: SendOtpBinding(),
      page: () => const SendOtpPage(),
    ),
    GetPage(
      name: AppRoutes.common.auth.verifyOtp,
      binding: VerifyOtpBinding(),
      page: () => const VerifyOtpPage(),
    ),
  ];

  static List<GetPage> get _ownerPages => [
    GetPage(
      name: AppRoutes.owner.dashboard,
      bindings: [
        OwnerDashboardBinding(),
        OwnerSettingsBinding(),
        NotificationBinding(),
      ],
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
    GetPage(
      name: AppRoutes.owner.addTeamMember,
      page: () => const AddTeamMemberPage(),
      binding: AddTeamMemberBinding(),
    ),
    GetPage(
      name: AppRoutes.owner.addMemberDetails,
      page: () => const AddMemberDetailsPage(),
      binding: AddTeamMemberBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.owner.team,
      page: () => const TeamStatusPage(),
      binding: TeamStatusBinding(),
    ),
    GetPage(
      name: AppRoutes.owner.teamMemberProfile,
      page: () => const TeamMemberProfilePage(),
      binding: TeamMemberProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.owner.jobs,
      page: () => const JobsPage(),
      binding: JobsBinding(),
    ),
    GetPage(
      name: AppRoutes.owner.createJob,
      page: () => const CreateJobPage(),
      binding: CreateJobBinding(),
    ),
    GetPage(
      name: AppRoutes.owner.jobDetails,
      page: () => const JobDetailsPage(),
      binding: JobDetailsBinding(),
    ),
  ];

  static List<GetPage> get _workerPages => [
    GetPage(
      name: AppRoutes.worker.dashboard,
      bindings: [
        AuthBindings(),
        AttendanceBinding(),
        WorkerDashboardBinding(),
        WorkerSettingsBinding(),
        NotificationBinding(),
      ],
      page: () => const WorkerDashboardPage(),
    ),
    GetPage(
      name: AppRoutes.worker.profile,
      binding: WorkerProfileBinding(),
      page: () => const WorkerProfilePage(),
    ),
  ];
}
