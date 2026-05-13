import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/services/settings/settings_pref_service.dart';
import 'package:trackyond/features/owner/settings/data/repositories/owner_settings_repository_impl.dart';
import 'package:trackyond/features/owner/settings/domain/repositories/i_owner_settings_repository.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/get_owner_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/get_owner_setting_use_case.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/save_owner_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/save_owner_setting_use_case.dart';
import 'package:trackyond/features/owner/settings/presentation/controllers/owner_settings_controller.dart';

class OwnerSettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => SettingsPrefService(Get.find<SharedPreferences>()));

    // Repositories
    Get.lazyPut<IOwnerSettingsRepository>(
      () => OwnerSettingsRepositoryImpl(Get.find()),
    );

    // Use cases
    Get.lazyPut(() => GetOwnerSettingUseCase(Get.find()));
    Get.lazyPut(() => SaveOwnerSettingUseCase(Get.find()));
    Get.lazyPut(() => GetOwnerDashboardStatsFilterUseCase(Get.find()));
    Get.lazyPut(() => SaveOwnerDashboardStatsFilterUseCase(Get.find()));

    // Controllers - Make permanent so accessible everywhere
    Get.put(
      OwnerSettingsController(
        getSettingUseCase: Get.find(),
        saveSettingUseCase: Get.find(),
        getDashboardStatsFilterUseCase: Get.find(),
        saveDashboardStatsFilterUseCase: Get.find(),
      ),
      permanent: true,
    );
  }
}
