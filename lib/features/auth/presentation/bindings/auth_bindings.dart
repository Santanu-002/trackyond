import 'package:get/get.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';

class AuthBindings extends Bindings{
  @override
  void dependencies() {
   Get.put( AuthController(),permanent: true);
  }

}