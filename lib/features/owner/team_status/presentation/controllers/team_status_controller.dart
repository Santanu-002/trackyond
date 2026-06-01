import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/filter/app_chip_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_stats_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/features/owner/settings/presentation/controllers/owner_settings_controller.dart';

class TeamStatusController extends GetxController {
  final GetTeamStatusUseCase _getTeamStatusUseCase;

  static const String _searchByPrefKey = 'team_status_search_by';

  List<AppChipEntity<AttendanceStatus?>> get filterEntities => [
    AppChipEntity(
      label: 'All',
      value: null,
      onTap: () => setStatusFilter(null),
    ),
    AppChipEntity(
      label: 'Working',
      value: AttendanceStatus.working,
      onTap: () => setStatusFilter(AttendanceStatus.working),
    ),
    AppChipEntity(
      label: 'Not Started',
      value: AttendanceStatus.notStarted,
      onTap: () => setStatusFilter(AttendanceStatus.notStarted),
    ),
  ];

  TeamStatusController({required GetTeamStatusUseCase getTeamStatusUseCase})
    : _getTeamStatusUseCase = getTeamStatusUseCase;

  final isLoading = false.obs;

  /// Raw list from the API — always contains all statuses.
  final _allMembers = <TeamMemberStatusEntity>[].obs;

  // Stats (always reflect the full dataset from API)
  final stats = const TeamStatusStatsEntity(
    total: 0,
    working: 0,
    notStarted: 0,
  ).obs;

  // Filters & Search
  final selectedStatus = Rxn<AttendanceStatus>();

  final selectedOrder = SortOrder.desc.obs;
  final searchQuery = ''.obs;
  final searchBy = 'All'.obs;

  // ---------------------------------------------------------------------------
  // Derived list: status-filtered → sorted → search-filtered
  // ---------------------------------------------------------------------------

  List<TeamMemberStatusEntity> get filteredMembers {
    // 1. Status filter (local — no re-fetch needed)
    final statusFiltered = selectedStatus.value == null
        ? _allMembers.toList()
        : _allMembers.where((m) => m.status == selectedStatus.value).toList();

    // 2. Sort: working always first; within each group order by startAt.
    _sortInPlace(statusFiltered);

    // 3. Search filter
    if (searchQuery.isEmpty) return statusFiltered;

    final query = searchQuery.value.toLowerCase();
    final keywords = query.split(' ').where((k) => k.isNotEmpty).toList();

    final searched = statusFiltered.where((m) {
      String searchableString;
      switch (searchBy.value) {
        case 'Name':
          searchableString = m.profile.name;
          break;
        case 'Designation':
          searchableString = m.profile.designation;
          break;
        case 'Phone':
          searchableString = m.profile.phone;
          break;
        default:
          searchableString =
              '${m.profile.name} ${m.profile.designation} ${m.profile.phone}';
      }
      searchableString = searchableString.toLowerCase();
      return keywords.every((keyword) => searchableString.contains(keyword));
    }).toList();

    // Re-sort by relevance, but preserve working-first invariant.
    searched.sort((a, b) {
      final statusCmp = _statusPriority(a).compareTo(_statusPriority(b));
      if (statusCmp != 0) return statusCmp;
      return _searchScore(
        a,
        query,
        keywords,
      ).compareTo(_searchScore(b, query, keywords));
    });

    return searched;
  }

  // ---------------------------------------------------------------------------
  // Sorting helpers
  // ---------------------------------------------------------------------------

  /// Working = 0, NotStarted = 1 — so working members sort before not-started.
  int _statusPriority(TeamMemberStatusEntity m) => m.isWorking ? 0 : 1;

  /// Sorts [list] in-place: working first, then by startAt per selectedOrder.
  void _sortInPlace(List<TeamMemberStatusEntity> list) {
    final isDesc = selectedOrder.value == SortOrder.desc;
    list.sort((a, b) {
      // Tier 1: working before not-started (always).
      final statusCmp = _statusPriority(a).compareTo(_statusPriority(b));
      if (statusCmp != 0) return statusCmp;

      // Tier 2: sort by startAt within the same status group.
      final aTime = a.startAt;
      final bTime = b.startAt;

      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1; // nulls pushed to the end
      if (bTime == null) return -1;

      return isDesc
          ? bTime.compareTo(aTime) // newest first
          : aTime.compareTo(bTime); // oldest first
    });
  }

  int _searchScore(
    TeamMemberStatusEntity m,
    String query,
    List<String> keywords,
  ) {
    final nameLower = m.profile.name.toLowerCase();
    final designationLower = (m.profile.designation).toLowerCase();
    final phoneLower = m.profile.phone.toLowerCase();

    if (nameLower.contains(query)) return 1;
    if (designationLower.contains(query)) return 2;
    if (phoneLower.contains(query)) return 3;
    if (keywords.any((k) => nameLower.contains(k))) return 4;
    if (keywords.any((k) => designationLower.contains(k))) return 5;
    if (keywords.any((k) => phoneLower.contains(k))) return 6;
    return 7;
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  void setSearchQuery(String query) => searchQuery.value = query;

  void clearSearch() => searchQuery.value = '';

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _loadSearchPreference();
    ever(searchBy, (String value) {
      final settingsController = Get.find<OwnerSettingsController>();
      settingsController.saveSetting(_searchByPrefKey, value);
    });
    fetchTeamStatus();
  }

  Future<void> _loadSearchPreference() async {
    final settingsController = Get.find<OwnerSettingsController>();
    final result = await settingsController.getStringSetting(_searchByPrefKey);
    if (result != null) {
      searchBy.value = result;
    }
  }

  // ---------------------------------------------------------------------------
  // Data fetching — fetches all members without server-side filters.
  // ---------------------------------------------------------------------------

  Future<void> fetchTeamStatus() async {
    isLoading.value = true;
    final result = await _getTeamStatusUseCase(GetTeamStatusParams());

    result.fold((failure) => AppSnackbar.destructive(failure.message), (
      teamStatus,
    ) {
      _allMembers.assignAll(teamStatus.members);
      stats.value = teamStatus.stats;
    });
    isLoading.value = false;
  }

  // ---------------------------------------------------------------------------
  // Filter / order setters — reactive; no API re-fetch needed.
  // ---------------------------------------------------------------------------

  void setStatusFilter(AttendanceStatus? status) {
    selectedStatus.value = status;
    _allMembers.refresh(); // notify Obx widgets
  }

  void setOrder(SortOrder order) {
    selectedOrder.value = order;
    _allMembers.refresh(); // notify Obx widgets
  }

  // ---------------------------------------------------------------------------
  // Search-by label helpers
  // ---------------------------------------------------------------------------

  String get searchByLabel => getSearchByLabel(searchBy.value);

  String getSearchByLabel(String value) {
    switch (value) {
      case 'All':
        return AppStrings.teamStatus.searchByAll;
      case 'Name':
        return AppStrings.teamStatus.searchByName;
      case 'Designation':
        return AppStrings.teamStatus.searchByDesignation;
      case 'Phone':
        return AppStrings.teamStatus.searchByPhone;
      default:
        return value;
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void goToMemberProfile(TeamMemberStatusEntity member) {
    Get.toNamed(AppRoutes.owner.teamMemberProfile, arguments: member);
  }
}
