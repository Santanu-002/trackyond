import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/get_owner_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/get_owner_setting_use_case.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/save_owner_dashboard_stats_filter_use_case.dart';
import 'package:trackyond/features/owner/settings/domain/usecases/save_owner_setting_use_case.dart';

class OwnerSettingsController extends GetxController {
  final GetOwnerSettingUseCase _getSettingUseCase;
  final SaveOwnerSettingUseCase _saveSettingUseCase;
  final GetOwnerDashboardStatsFilterUseCase _getDashboardStatsFilterUseCase;
  final SaveOwnerDashboardStatsFilterUseCase _saveDashboardStatsFilterUseCase;

  OwnerSettingsController({
    required GetOwnerSettingUseCase getSettingUseCase,
    required SaveOwnerSettingUseCase saveSettingUseCase,
    required GetOwnerDashboardStatsFilterUseCase getDashboardStatsFilterUseCase,
    required SaveOwnerDashboardStatsFilterUseCase saveDashboardStatsFilterUseCase,
  })  : _getSettingUseCase = getSettingUseCase,
        _saveSettingUseCase = saveSettingUseCase,
        _getDashboardStatsFilterUseCase = getDashboardStatsFilterUseCase,
        _saveDashboardStatsFilterUseCase = saveDashboardStatsFilterUseCase;

  // ============== SETTINGS ==============

  Future<dynamic> getSetting(String key, Type type) async {
    final res = await _getSettingUseCase(GetOwnerSettingParams(key: key, type: type));
    return res.fold((_) => null, (v) => v);
  }

  Future<void> saveSetting(String key, dynamic value) async {
    await _saveSettingUseCase(SaveOwnerSettingParams(key: key, value: value));
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
    return res.fold((_) => StatsFilter.today, (val) => StatsFilter.fromString(val));
  }

  Future<void> saveDashboardStatsFilter(StatsFilter filter) async {
    await _saveDashboardStatsFilterUseCase(filter.value);
  }
}
