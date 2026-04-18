import 'package:get/get.dart';
import 'package:trackyond/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:trackyond/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:trackyond/features/auth/presentation/controllers/verify_otp_controller.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendOtpUseCase(Get.find()));
    Get.lazyPut(() => VerifyOtpUseCase(Get.find()));
    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(
        sendOtpUseCase: Get.find(),
        verifyOtpUseCase: Get.find(),
      ),
    );
  }
}
