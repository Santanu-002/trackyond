import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/common/entities/filter_rule_entity.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/get_jobs_use_case.dart';
import 'package:trackyond/core/common/entities/job/job_filter_options.dart';
import 'package:trackyond/core/common/entities/job/job_sort_options.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/filter_bottom_sheet.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/sort_bottom_sheet.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/app_chip_entity.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/status_picker_sheet.dart';

class JobsController extends GetxController {
  final GetJobsUseCase _getJobsUseCase;
  final GetTeamStatusUseCase _getTeamStatusUseCase;

  JobsController({
    required GetJobsUseCase getJobsUseCase,
    required GetTeamStatusUseCase getTeamStatusUseCase,
  }) : _getJobsUseCase = getJobsUseCase,
       _getTeamStatusUseCase = getTeamStatusUseCase;

  static const int _pageSize = 20;

  final ScrollController scrollController = ScrollController();
  final RxList<JobEntity> jobs = <JobEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;
  int _offset = 0;

  // Filter & Sort State
  final filter = const JobFilterOptions().obs;
  final sort = const JobSortOptions().obs;

  // Search State
  final searchQuery = ''.obs;
  final searchBy = JobSearchField.all.obs;

  // Worker Filter State
  final workerSearchQuery = ''.obs;
  final workerSearchBy = 'All'.obs;
  final isWorkersLoading = false.obs;
  final _allFetchedMembers = <TeamMemberStatusEntity>[].obs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(_onScroll);

    // Listen to changes in search query and filters
    debounce(
      searchQuery,
      (_) => fetchJobs(refresh: true),
      time: const Duration(milliseconds: 500),
    );

    ever(filter, (_) => fetchJobs(refresh: true));
    ever(sort, (_) => fetchJobs(refresh: true));
    ever(searchBy, (_) => fetchJobs(refresh: true));

    // Worker Filter Listeners
    debounce(
      workerSearchQuery,
      (_) => fetchWorkers(),
      time: const Duration(milliseconds: 500),
    );
    ever(workerSearchBy, (_) => fetchWorkers());

    fetchWorkers(limit: 50);
  }

  @override
  void onReady() {
    super.onReady();
    // Explicitly trigger initial load
    fetchJobs(refresh: true);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoading.value && !isMoreLoading.value && hasMore.value) {
        fetchJobs();
      }
    }
  }

  Future<void> fetchJobs({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      hasMore.value = true;
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    final currentFilter = filter.value.copyWith(
      search: searchQuery.value,
      searchBy: searchBy.value,
    );

    // Instant Validation: Check for invalid date range
    final dateRule = currentFilter.advancedFilter.rules.firstWhereOrNull(
      (rule) => rule.field == 'date',
    );
    if (dateRule != null &&
        dateRule.value is List &&
        (dateRule.value as List).length == 2) {
      final start = (dateRule.value as List)[0] as DateTime;
      final end = (dateRule.value as List)[1] as DateTime;
      if (start.isAfter(end)) {
        AppSnackbar.destructive(AppStrings.jobs.startDateAfterEndDateError);
        if (refresh) {
          isLoading.value = false;
        } else {
          isMoreLoading.value = false;
        }
        return;
      }
    }

    final result = await _getJobsUseCase(
      GetJobsParams(
        limit: _pageSize,
        offset: _offset,
        filter: currentFilter,
        sort: sort.value,
      ),
    );

    result.fold(
      (failure) {
        AppSnackbar.destructive(failure.message);
        if (refresh) {
          isLoading.value = false;
        } else {
          isMoreLoading.value = false;
        }
      },
      (newItems) async {
        if (refresh) {
          jobs.assignAll(newItems);
          isLoading.value = false;
        } else {
          jobs.addAll(newItems);
          isMoreLoading.value = false;
        }

        if (newItems.length < _pageSize) {
          hasMore.value = false;
        } else {
          _offset += newItems.length;
        }
      },
    );
  }

  void refreshJobs() {
    fetchJobs(refresh: true);
  }

  // Filter & Sort Getters
  int get activeFilterCount {
    int count = 0;
    if (searchQuery.value.isNotEmpty) count++;
    count += filter.value.advancedFilter.rules.length;
    count += filter.value.advancedFilter.groups.length;
    return count;
  }

  // Filter Actions
  void setStatus(JobStatus? status) {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    final statusRule = currentRules.firstWhereOrNull(
      (rule) => rule.field == 'status',
    );

    List<JobStatus> selectedStatuses = [];
    if (statusRule != null && statusRule.value is List) {
      selectedStatuses = List<JobStatus>.from(statusRule.value as List);
    }

    if (status != null) {
      if (selectedStatuses.contains(status)) {
        selectedStatuses.remove(status);
      } else {
        selectedStatuses.add(status);
      }
    }

    final statusIndex = currentRules.indexWhere(
      (rule) => rule.field == 'status',
    );

    if (selectedStatuses.isEmpty) {
      if (statusIndex != -1) {
        removeRule(statusIndex);
      }
    } else {
      final newRule = FilterRuleEntity(
        field: 'status',
        operator: FilterOperator.inList,
        value: selectedStatuses,
      );

      if (statusIndex != -1) {
        updateRule(statusIndex, newRule);
      } else {
        addRule(newRule);
      }
    }
  }

  bool isStatusSelected(JobStatus? status) {
    final statusRule = filter.value.advancedFilter.rules.firstWhereOrNull(
      (rule) => rule.field == 'status',
    );

    if (status == null) {
      return statusRule == null || (statusRule.value as List).isEmpty;
    }

    if (statusRule == null) return false;
    return (statusRule.value as List).contains(status);
  }

  // Quick Filter State
  final RxnInt activeDateFilterIndex = RxnInt();

  void setDateRange(DateTime? from, DateTime? to, {int? quickFilterIndex}) {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    currentRules.removeWhere((rule) => rule.field == 'date');

    if (from != null && to != null) {
      currentRules.add(
        FilterRuleEntity(
          field: 'date',
          operator: FilterOperator.between,
          value: [from, to],
        ),
      );
    }

    activeDateFilterIndex.value = quickFilterIndex;

    filter.value = filter.value.copyWith(
      advancedFilter: filter.value.advancedFilter.copyWith(rules: currentRules),
    );
  }

  DateTime? get fromDate {
    final dateRule = filter.value.advancedFilter.rules.firstWhereOrNull(
      (rule) => rule.field == 'date',
    );
    if (dateRule == null || (dateRule.value as List).isEmpty) return null;
    return (dateRule.value as List)[0] as DateTime;
  }

  DateTime? get toDate {
    final dateRule = filter.value.advancedFilter.rules.firstWhereOrNull(
      (rule) => rule.field == 'date',
    );
    if (dateRule == null || (dateRule.value as List).length < 2) return null;
    return (dateRule.value as List)[1] as DateTime;
  }

  bool get isTodaySelected => activeDateFilterIndex.value == 0;

  bool get isThisWeekSelected => activeDateFilterIndex.value == 1;

  bool get isThisMonthSelected => activeDateFilterIndex.value == 2;

  bool get isLast3MonthsSelected => activeDateFilterIndex.value == 3;

  void addRule(FilterRuleEntity rule) {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    final currentOps = List<LogicalOperator>.from(
      filter.value.advancedFilter.operators,
    );

    // Smart Merging: If adding a rule for a field that already exists, merge them
    final existingIndex = currentRules.indexWhere((r) => r.field == rule.field);

    if (existingIndex != -1) {
      final existingRule = currentRules[existingIndex];
      // Only merge if operators are compatible (e.g., both are equal or inList)
      if (existingRule.operator == FilterOperator.equals ||
          existingRule.operator == FilterOperator.inList) {
        List<dynamic> mergedValues = [];
        if (existingRule.value is List) {
          mergedValues = List<dynamic>.from(existingRule.value as List);
        } else {
          mergedValues = [existingRule.value];
        }

        if (rule.value is List) {
          mergedValues.addAll(rule.value as List);
        } else {
          if (!mergedValues.contains(rule.value)) {
            mergedValues.add(rule.value);
          }
        }

        updateRule(
          existingIndex,
          existingRule.copyWith(
            operator: FilterOperator.inList,
            value: mergedValues,
          ),
        );
        return;
      }
    }

    if (currentRules.isNotEmpty) {
      currentOps.add(LogicalOperator.and); // Default connector
    }

    currentRules.add(rule);
    filter.value = filter.value.copyWith(
      advancedFilter: filter.value.advancedFilter.copyWith(
        rules: currentRules,
        operators: currentOps,
      ),
    );
  }

  void removeRule(int index) {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    final currentOps = List<LogicalOperator>.from(
      filter.value.advancedFilter.operators,
    );

    if (index >= 0 && index < currentRules.length) {
      currentRules.removeAt(index);
      // Remove corresponding operator
      if (index < currentOps.length) {
        currentOps.removeAt(index);
      } else if (currentOps.isNotEmpty) {
        currentOps.removeLast();
      }

      filter.value = filter.value.copyWith(
        advancedFilter: filter.value.advancedFilter.copyWith(
          rules: currentRules,
          operators: currentOps,
        ),
      );
    }
  }

  void updateOperator(int index, LogicalOperator op) {
    final currentOps = List<LogicalOperator>.from(
      filter.value.advancedFilter.operators,
    );
    if (index >= 0 && index < currentOps.length) {
      currentOps[index] = op;
      filter.value = filter.value.copyWith(
        advancedFilter: filter.value.advancedFilter.copyWith(
          logicalOperator: op, // Sync the main operator as well
          operators: currentOps,
        ),
      );
    }
  }

  void updateRule(int index, FilterRuleEntity rule) {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    if (index >= 0 && index < currentRules.length) {
      currentRules[index] = rule;
      filter.value = filter.value.copyWith(
        advancedFilter: filter.value.advancedFilter.copyWith(
          rules: currentRules,
        ),
      );
    }
  }

  void setLogicalOperator(LogicalOperator operator) {
    filter.value = filter.value.copyWith(
      advancedFilter: filter.value.advancedFilter.copyWith(
        logicalOperator: operator,
      ),
    );
  }

  void setSort(JobSortField field, SortOrder order) {
    sort.value = sort.value.copyWith(field: field, order: order);
  }

  void clearFilters() {
    filter.value = const JobFilterOptions();
    searchQuery.value = '';
    activeDateFilterIndex.value = null;
    sort.value = const JobSortOptions();
    workerSearchQuery.value = '';
  }

  // Worker Filter Actions
  Future<void> fetchWorkers({int? limit}) async {
    isWorkersLoading.value = true;
    final result = await _getTeamStatusUseCase.call(
      GetTeamStatusParams(limit: limit ?? 50),
    );
    isWorkersLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (teamStatus) => _allFetchedMembers.assignAll(teamStatus.members),
    );
  }

  List<TeamMemberStatusEntity> get filteredMembers {
    final selectedIds = selectedWorkers.map((w) => w.accountUid).toSet();

    // Filter out already selected members
    final availableMembers = _allFetchedMembers.where(
      (m) => !selectedIds.contains(m.profile.accountUid),
    );

    if (workerSearchQuery.isEmpty) {
      return availableMembers.toList();
    }

    final query = workerSearchQuery.value.toLowerCase();
    return availableMembers.where((m) {
      final searchableString = switch (workerSearchBy.value) {
        'Name' => m.profile.name,
        'Designation' => m.profile.designation,
        'Phone' => m.profile.phone,
        _ => '${m.profile.name} ${m.profile.designation} ${m.profile.phone}',
      };
      return searchableString.toLowerCase().contains(query);
    }).toList();
  }

  List<MemberProfile> get selectedWorkers {
    final workerRule = filter.value.advancedFilter.rules.firstWhereOrNull(
      (rule) => rule.field == 'worker',
    );
    if (workerRule == null || workerRule.value is! List) return [];
    return List<MemberProfile>.from(workerRule.value as List);
  }

  void toggleWorker(MemberProfile worker) {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    final workerIndex = currentRules.indexWhere(
      (rule) => rule.field == 'worker',
    );

    List<MemberProfile> selected = [];
    if (workerIndex != -1 && currentRules[workerIndex].value is List) {
      selected = List<MemberProfile>.from(
        currentRules[workerIndex].value as List,
      );
    }

    if (selected.any((w) => w.accountUid == worker.accountUid)) {
      selected.removeWhere((w) => w.accountUid == worker.accountUid);
    } else {
      selected.add(worker);
    }

    if (selected.isEmpty) {
      if (workerIndex != -1) removeRule(workerIndex);
    } else {
      final newRule = FilterRuleEntity(
        field: 'worker',
        operator: FilterOperator.inList,
        value: selected,
      );

      if (workerIndex != -1) {
        updateRule(workerIndex, newRule);
      } else {
        addRule(newRule);
      }
    }
  }

  bool isWorkerSelected(MemberProfile worker) {
    return selectedWorkers.any((w) => w.accountUid == worker.accountUid);
  }

  bool get isFilteringActive =>
      activeFilterCount > 0 ||
      searchQuery.value.isNotEmpty ||
      selectedWorkers.isNotEmpty;

  void clearSearch() {
    searchQuery.value = '';
  }

  void clearDateFilter() {
    setDateRange(null, null);
  }

  void clearStatusFilter() {
    final currentRules = List<FilterRuleEntity>.from(
      filter.value.advancedFilter.rules,
    );
    currentRules.removeWhere((rule) => rule.field == 'status');
    filter.value = filter.value.copyWith(
      advancedFilter: filter.value.advancedFilter.copyWith(rules: currentRules),
    );
  }

  List<AppChipEntity<VoidCallback>> get dateFilterChips => [
    AppChipEntity(
      label: AppStrings.jobs.today,
      value: setQuickFilterToday,
      onTap: setQuickFilterToday,
    ),
    AppChipEntity(
      label: AppStrings.jobs.thisWeek,
      value: setQuickFilterThisWeek,
      onTap: setQuickFilterThisWeek,
    ),
    AppChipEntity(
      label: AppStrings.jobs.thisMonth,
      value: setQuickFilterThisMonth,
      onTap: setQuickFilterThisMonth,
    ),
    AppChipEntity(
      label: AppStrings.jobs.last3Months,
      value: setQuickFilterLast3Months,
      onTap: setQuickFilterLast3Months,
    ),
  ];

  // Helpers for UI
  String getSearchByLabel(JobSearchField field) => switch (field) {
    JobSearchField.all => AppStrings.jobs.searchByAll,
    JobSearchField.title => AppStrings.jobs.searchByTitle,
    JobSearchField.customer => AppStrings.jobs.searchByCustomer,
    JobSearchField.address => AppStrings.jobs.searchByAddress,
    JobSearchField.worker => AppStrings.jobs.searchByWorker,
  };

  String getWorkerSearchByLabel(String value) => switch (value) {
    'All' => AppStrings.teamStatus.searchByAll,
    'Name' => AppStrings.teamStatus.searchByName,
    'Designation' => AppStrings.teamStatus.searchByDesignation,
    'Phone' => AppStrings.teamStatus.searchByPhone,
    _ => value,
  };

  String getSortFieldLabel(JobSortField field) => switch (field) {
    JobSortField.createdAt => AppStrings.jobs.sortDateCreated,
    JobSortField.jobTitle => AppStrings.jobs.sortJobTitle,
    JobSortField.status => AppStrings.jobs.sortStatus,
    JobSortField.customerName => AppStrings.jobs.sortCustomerName,
    JobSortField.workerName => AppStrings.jobs.sortWorkerName,
    JobSortField.assignedAt => AppStrings.jobs.sortAssignedAt,
    JobSortField.completedAt => AppStrings.jobs.sortCompletedAt,
    JobSortField.startedAt => AppStrings.jobs.sortStartedAt,
    JobSortField.updatedAt => AppStrings.jobs.sortUpdatedAt,
  };

  // Quick Filter Actions
  void setQuickFilterToday() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59);

    if (activeDateFilterIndex.value == 0) {
      setDateRange(null, null);
    } else {
      setDateRange(start, end, quickFilterIndex: 0);
    }
  }

  void setQuickFilterThisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(start.year, start.month, start.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    if (activeDateFilterIndex.value == 1) {
      setDateRange(null, null);
    } else {
      setDateRange(startDate, end, quickFilterIndex: 1);
    }
  }

  void setQuickFilterThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    if (activeDateFilterIndex.value == 2) {
      setDateRange(null, null);
    } else {
      setDateRange(start, end, quickFilterIndex: 2);
    }
  }

  void setQuickFilterLast3Months() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 3, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    if (activeDateFilterIndex.value == 3) {
      setDateRange(null, null);
    } else {
      setDateRange(start, end, quickFilterIndex: 3);
    }
  }

  Color getStatusColor(JobStatus status, ColorScheme scheme) =>
      switch (status) {
        JobStatus.pending => scheme.pending,
        JobStatus.assigned => scheme.primary,
        JobStatus.inProgress => scheme.inProgress,
        JobStatus.completed => scheme.completed,
        JobStatus.cancelled => scheme.error,
      };

  String getFieldLabel(String field) => switch (field) {
    'status' => AppStrings.jobs.status,
    'date' => AppStrings.jobs.date,
    'worker' => AppStrings.jobs.members,
    _ => field,
  };

  String getValueLabel(dynamic value) {
    if (value is List) {
      if (value.isNotEmpty && value[0] is DateTime) {
        final format = DateFormat('dd MMM yyyy');
        if (value.length == 2) {
          return '${format.format(value[0] as DateTime)} - ${format.format(value[1] as DateTime)}';
        }
        return format.format(value[0] as DateTime);
      }
      return value
          .map(
            (v) => v is JobStatus
                ? v.name.capitalizeFirst
                : v is MemberProfile
                ? v.name
                : v.toString(),
          )
          .join(', ');
    }
    return value.toString();
  }

  void showStatusPicker() {
    Get.bottomSheet(
      const StatusPickerSheet(),
      isScrollControlled: true,
    );
  }

  Future<void> showDatePicker() async {
    final initialDateRange = fromDate != null
        ? DateTimeRange(
            start: fromDate!,
            end: fromDate!.add(const Duration(days: 1)),
          )
        : null;

    final pickedRange = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: initialDateRange,
    );

    if (pickedRange != null) {
      setDateRange(pickedRange.start, pickedRange.end);
    }
  }

  void showSortBottomSheet() {
    Get.bottomSheet(const SortBottomSheet(), isScrollControlled: true);
  }

  void showFilterBottomSheet() {
    Get.bottomSheet(const FilterBottomSheet(), isScrollControlled: true);
  }

  void goToJobDetails(JobEntity job) {
    Get.toNamed(AppRoutes.owner.jobDetails, arguments: job);
  }
}
