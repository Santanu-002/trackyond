import 'package:get/get.dart';
import 'package:trackyond/features/notification/presentation/controllers/notifications_page_controller.dart';

class NotificationsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsPageController>(
      () => NotificationsPageController(),
    );
  }
}
