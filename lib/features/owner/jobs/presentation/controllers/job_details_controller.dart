import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';

class JobDetailsController extends GetxController {
  final _job = Rxn<JobEntity>();
  JobEntity? get job => _job.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is JobEntity) {
      _job.value = args;
    }
  }

  void onBack() {
    Get.back();
  }
}
