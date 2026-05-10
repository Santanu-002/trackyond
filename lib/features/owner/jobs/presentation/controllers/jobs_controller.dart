import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/filter_enums.dart';
import 'package:trackyond/core/common/entities/filter_rule_entity.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/get_jobs_use_case.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_filter_options.dart';
import 'package:trackyond/features/owner/jobs/domain/entities/job_sort_options.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter_bottom_sheet.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/sort_bottom_sheet.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';

class JobsController extends GetxController {
  final GetJobsUseCase _getJobsUseCase;
  final GetTeamStatusUseCase _getTeamStatusUseCase;

  JobsController({
    required GetJobsUseCase getJobsUseCase,
    required GetTeamStatusUseCase getTeamStatusUseCase,
  })  : _getJobsUseCase = getJobsUseCase,
        _getTeamStatusUseCase = getTeamStatusUseCase;

  static const int _pageSize = 20;

  late final PagingController<int, JobEntity> pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.lastPageIsEmpty) return null;
      final pagesList = state.pages?.toList() ?? [];
      final keysList = state.keys?.toList() ?? [];

      if (pagesList.isEmpty) return null;

      final lastPage = pagesList.last;
      if (lastPage.length < _pageSize) return null;

      final lastKey = keysList.last;
      return lastKey + lastPage.length;
    },
    fetchPage: _fetchPage,
  );

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

    // Listen to changes in search query and filters
    debounce(searchQuery, (_) => refreshJobs(),
        time: const Duration(milliseconds: 500));

    ever(filter, (_) => refreshJobs());
    ever(sort, (_) => refreshJobs());
    ever(searchBy, (_) => refreshJobs());

    // Worker Filter Listeners
    debounce(workerSearchQuery, (_) => fetchWorkers(),
        time: const Duration(milliseconds: 500));
    ever(workerSearchBy, (_) => fetchWorkers());

    fetchWorkers(limit: 50);
    
    // Explicitly trigger initial load
    refreshJobs();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<List<JobEntity>> _fetchPage(int pageKey) async {
    final currentFilter = filter.value.copyWith(
      search: searchQuery.value,
      searchBy: searchBy.value,
    );

    final result = await _getJobsUseCase(GetJobsParams(
      limit: _pageSize,
      offset: pageKey,
      filter: currentFilter,
      sort: sort.value,
    ));

    return result.fold(
      (failure) => throw failure.message,
      (newItems) => newItems,
    );
  }

  void refreshJobs() {
    pagingController.refresh();
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
    final currentRules =
        List<FilterRuleEntity>.from(filter.value.advancedFilter.rules);
    final statusRule =
        currentRules.firstWhereOrNull((rule) => rule.field == 'status');

    List<JobStatus> selectedStatuses = [];
    if (statusRule != null && statusRule.value is List) {
      selectedStatuses = List<JobStatus>.from(statusRule.value as List);
    }

    if (status == null) {
      selectedStatuses.clear();
    } else {
      if (selectedStatuses.contains(status)) {
        selectedStatuses.remove(status);
      } else {
        selectedStatuses.add(status);
      }
    }

    final statusIndex =
        currentRules.indexWhere((rule) => rule.field == 'status');

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

  void setDateRange(DateTime? from, DateTime? to) {
    final currentRules =
        List<FilterRuleEntity>.from(filter.value.advancedFilter.rules);
    currentRules.removeWhere((rule) => rule.field == 'date');

    if (from != null && to != null) {
      currentRules.add(FilterRuleEntity(
        field: 'date',
        operator: FilterOperator.between,
        value: [from, to],
      ));
    }

    filter.value = filter.value.copyWith(
      advancedFilter: filter.value.advancedFilter.copyWith(rules: currentRules),
    );
  }

  DateTime? get fromDate {
    final dateRule = filter.value.advancedFilter.rules.firstWhereOrNull(
      (rule) => rule.field == 'date',
    );
    if (dateRule == null) return null;
    return (dateRule.value as List)[0] as DateTime;
  }

  void addRule(FilterRuleEntity rule) {
    final currentRules =
        List<FilterRuleEntity>.from(filter.value.advancedFilter.rules);
    final currentOps =
        List<LogicalOperator>.from(filter.value.advancedFilter.operators);

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
    final currentRules =
        List<FilterRuleEntity>.from(filter.value.advancedFilter.rules);
    final currentOps =
        List<LogicalOperator>.from(filter.value.advancedFilter.operators);

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
    final currentOps =
        List<LogicalOperator>.from(filter.value.advancedFilter.operators);
    if (index >= 0 && index < currentOps.length) {
      currentOps[index] = op;
      filter.value = filter.value.copyWith(
        advancedFilter:
            filter.value.advancedFilter.copyWith(operators: currentOps),
      );
    }
  }

  void updateRule(int index, FilterRuleEntity rule) {
    final currentRules =
        List<FilterRuleEntity>.from(filter.value.advancedFilter.rules);
    if (index >= 0 && index < currentRules.length) {
      currentRules[index] = rule;
      filter.value = filter.value.copyWith(
        advancedFilter:
            filter.value.advancedFilter.copyWith(rules: currentRules),
      );
    }
  }

  void setLogicalOperator(LogicalOperator operator) {
    filter.value = filter.value.copyWith(
      advancedFilter:
          filter.value.advancedFilter.copyWith(logicalOperator: operator),
    );
  }

  void setSort(JobSortField field, SortOrder order) {
    sort.value = sort.value.copyWith(field: field, order: order);
  }

  void clearFilters() {
    filter.value = const JobFilterOptions();
    searchQuery.value = '';
    sort.value = const JobSortOptions();
    workerSearchQuery.value = '';
  }

  // Worker Filter Actions
  Future<void> fetchWorkers({int? limit}) async {
    isWorkersLoading.value = true;
    final result = await _getTeamStatusUseCase.call(GetTeamStatusParams(
      limit: limit ?? 50,
    ));
    isWorkersLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (teamStatus) => _allFetchedMembers.assignAll(teamStatus.members),
    );
  }

  List<TeamMemberStatusEntity> get filteredMembers {
    final selectedIds = selectedWorkers.map((w) => w.accountUid).toSet();

    // Filter out already selected members
    final availableMembers =
        _allFetchedMembers.where((m) => !selectedIds.contains(m.profile.accountUid));

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
    final workerRule = filter.value.advancedFilter.rules
        .firstWhereOrNull((rule) => rule.field == 'worker');
    if (workerRule == null || workerRule.value is! List) return [];
    return List<MemberProfile>.from(workerRule.value as List);
  }

  void toggleWorker(MemberProfile worker) {
    final currentRules =
        List<FilterRuleEntity>.from(filter.value.advancedFilter.rules);
    final workerIndex =
        currentRules.indexWhere((rule) => rule.field == 'worker');

    List<MemberProfile> selected = [];
    if (workerIndex != -1 && currentRules[workerIndex].value is List) {
      selected =
          List<MemberProfile>.from(currentRules[workerIndex].value as List);
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

  // Helpers for UI
  String getSearchByLabel(JobSearchField field) => switch (field) {
        JobSearchField.all => 'All',
        JobSearchField.title => 'Title',
        JobSearchField.customer => 'Customer',
        JobSearchField.address => 'Address',
        JobSearchField.worker => 'Worker',
      };

  String getWorkerSearchByLabel(String value) => switch (value) {
        'All' => AppStrings.teamStatus.searchByAll,
        'Name' => AppStrings.teamStatus.searchByName,
        'Designation' => AppStrings.teamStatus.searchByDesignation,
        'Phone' => AppStrings.teamStatus.searchByPhone,
        _ => value,
      };

  String getSortFieldLabel(JobSortField field) => switch (field) {
        JobSortField.createdAt => 'Date Created',
        JobSortField.jobTitle => 'Job Title',
        JobSortField.status => 'Status',
        JobSortField.customerName => 'Customer Name',
        JobSortField.workerName => 'Worker Name',
        JobSortField.assignedAt => 'Assigned At',
        JobSortField.completedAt => 'Completed At',
        JobSortField.startedAt => 'Started At',
        JobSortField.updatedAt => 'Updated At',
      };

  // Quick Filter Actions
  void setQuickFilterToday() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59);
    setDateRange(start, end);
  }

  void setQuickFilterThisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setDateRange(DateTime(start.year, start.month, start.day), end);
  }

  void setQuickFilterThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setDateRange(start, end);
  }

  void setQuickFilterLast3Months() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 3, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setDateRange(start, end);
  }

  Color getStatusColor(JobStatus status, ColorScheme scheme) => switch (status) {
        JobStatus.pending => scheme.pending,
        JobStatus.assigned => scheme.primary,
        JobStatus.inProgress => scheme.inProgress,
        JobStatus.completed => scheme.completed,
        JobStatus.cancelled => scheme.error,
      };

  String getFieldLabel(String field) => switch (field) {
        'status' => 'Status',
        'date' => 'Date',
        'worker' => 'Worker',
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
          .map((v) => v is JobStatus
              ? v.name.capitalizeFirst
              : v is MemberProfile
                  ? v.name
                  : v.toString())
          .join(', ');
    }
    return value.toString();
  }

  Future<void> showAddFilterMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final selectedField = await showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(value: 'status', child: Text('Status')),
        const PopupMenuItem(value: 'date', child: Text('Date Range')),
      ],
    );

    if (!context.mounted) return;

    if (selectedField == 'status') {
      showStatusPicker(context);
    } else if (selectedField == 'date') {
      showDatePicker(context);
    }
  }

  void showStatusPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Statuses', style: context.textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: JobStatus.values.map((status) {
                return Obx(() {
                  final isSelected = isStatusSelected(status);
                  return FilterChip(
                    label: Text(status.name.capitalizeFirst!),
                    selected: isSelected,
                    onSelected: (_) => setStatus(status),
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () => Get.back(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDatePicker(BuildContext context) async {
    final initialDateRange = fromDate != null
        ? DateTimeRange(
            start: fromDate!, end: fromDate!.add(const Duration(days: 1)))
        : null;

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: initialDateRange,
    );

    if (pickedRange != null) {
      setDateRange(pickedRange.start, pickedRange.end);
    }
  }

  void showSortBottomSheet() {
    Get.bottomSheet(
      const SortBottomSheet(),
      isScrollControlled: true,
    );
  }

  void showFilterBottomSheet() {
    Get.bottomSheet(
      const FilterBottomSheet(),
      isScrollControlled: true,
    );
  }
}
