import 'package:get/get.dart';
import 'package:trackyond/features/camera/presentation/controllers/camera_controller.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppCameraController());
  }
}
