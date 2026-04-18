import 'package:get/get.dart';
import 'package:trackyond/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:trackyond/features/auth/presentation/controllers/send_otp_controller.dart';

class SendOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendOtpUseCase(Get.find()));
    Get.lazyPut<SendOtpController>(() => SendOtpController(Get.find()));
  }
}
