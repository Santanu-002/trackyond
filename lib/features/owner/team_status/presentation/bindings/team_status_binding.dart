import 'package:get/get.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_team_status_usecase.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';

class TeamStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeamStatusController(
          getTeamStatusUseCase: Get.find<GetTeamStatusUseCase>(),
        ));
  }
}
