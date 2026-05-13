import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/services/settings/settings_pref_service.dart';
import 'package:trackyond/features/worker/settings/data/repositories/worker_settings_repository_impl.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/get_worker_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/get_worker_setting_use_case.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/save_worker_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/save_worker_setting_use_case.dart';
import 'package:trackyond/features/worker/settings/presentation/controllers/worker_settings_controller.dart';

class WorkerSettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => SettingsPrefService(Get.find<SharedPreferences>()));

    // Repositories
    Get.lazyPut<IWorkerSettingsRepository>(
      () => WorkerSettingsRepositoryImpl(Get.find()),
    );

    // Use cases
    Get.lazyPut(() => GetWorkerSettingUseCase(Get.find()));
    Get.lazyPut(() => SaveWorkerSettingUseCase(Get.find()));
    Get.lazyPut(() => GetWorkerDashboardStatsFilterUseCase(Get.find()));
    Get.lazyPut(() => SaveWorkerDashboardStatsFilterUseCase(Get.find()));

    // Controllers - Make permanent so accessible everywhere
    Get.put(
      WorkerSettingsController(
        getSettingUseCase: Get.find(),
        saveSettingUseCase: Get.find(),
        getDashboardStatsFilterUseCase: Get.find(),
        saveDashboardStatsFilterUseCase: Get.find(),
      ),
      permanent: true,
    );
  }
}
