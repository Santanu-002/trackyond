import 'package:get/get.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/job_details_controller.dart';

class JobDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailsController>(
      () => JobDetailsController(),
    );
  }
}
