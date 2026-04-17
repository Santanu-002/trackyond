import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/features/auth/presentation/screens/send_otp_page.dart';
import 'package:trackyond/features/auth/presentation/screens/verify_otp_page.dart';

class AuthPages {
  const AuthPages._();

  static List<GetPage> get pages => [
    GetPage(
      name: AppRoutes.common.auth.sendOtp,
      page: () => const SendOtpPage(),
    ),
    GetPage(
      name: AppRoutes.common.auth.verifyOtp,
      page: () => const VerifyOtpPage(),
    ),
  ];
}
