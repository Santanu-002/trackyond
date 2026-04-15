import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:trackyond/features/auth/presentation/pages/auth_pages.dart';
import 'package:trackyond/features/auth/presentation/screens/auth_gate_page.dart';
import 'package:trackyond/features/auth/presentation/screens/choose_role_page.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage> pages = [
    ..._commonPages,
    ...AuthPages.pages,
  ];

  static final List<GetPage> _commonPages = [
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
  ];
}
