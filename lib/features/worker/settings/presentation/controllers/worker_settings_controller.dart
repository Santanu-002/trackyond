import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/get_worker_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/get_worker_setting_use_case.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/save_worker_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/worker/settings/domain/usecases/save_worker_setting_use_case.dart';

class WorkerSettingsController extends GetxController {
  final GetWorkerSettingUseCase _getSettingUseCase;
  final SaveWorkerSettingUseCase _saveSettingUseCase;
  final GetWorkerDashboardStatsFilterUseCase _getDashboardStatsFilterUseCase;
  final SaveWorkerDashboardStatsFilterUseCase _saveDashboardStatsFilterUseCase;

  WorkerSettingsController({
    required GetWorkerSettingUseCase getSettingUseCase,
    required SaveWorkerSettingUseCase saveSettingUseCase,
    required GetWorkerDashboardStatsFilterUseCase
    getDashboardStatsFilterUseCase,
    required SaveWorkerDashboardStatsFilterUseCase
    saveDashboardStatsFilterUseCase,
  }) : _getSettingUseCase = getSettingUseCase,
       _saveSettingUseCase = saveSettingUseCase,
       _getDashboardStatsFilterUseCase = getDashboardStatsFilterUseCase,
       _saveDashboardStatsFilterUseCase = saveDashboardStatsFilterUseCase;

  // ============== SETTINGS ==============

  Future<dynamic> getSetting(String key, Type type) async {
    final res = await _getSettingUseCase(
      GetWorkerSettingParams(key: key, type: type),
    );
    return res.fold((_) => null, (v) => v);
  }

  Future<void> saveSetting(String key, dynamic value) async {
    await _saveSettingUseCase(SaveWorkerSettingParams(key: key, value: value));
  }

  Future<bool> getBoolSetting(String key, {bool defaultValue = false}) async {
    return (await getSetting(key, bool)) as bool? ?? defaultValue;
  }

  Future<String?> getStringSetting(String key) async {
    return (await getSetting(key, String)) as String?;
  }

  // ============== DASHBOARD STATS FILTER ==============

  Future<StatsFilter> get dashboardStatsFilter async {
    final res = await _getDashboardStatsFilterUseCase(const NoParams());
    return res.fold(
      (_) => StatsFilter.today,
      (val) => StatsFilter.fromString(val),
    );
  }

  Future<void> saveDashboardStatsFilter(StatsFilter filter) async {
    await _saveDashboardStatsFilterUseCase(filter.value);
  }
}
