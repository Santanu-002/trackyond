import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/attendance_log.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/export_member_attendance_logs_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_member_attendance_logs_usecase.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMemberAttendanceController extends GetxController {
  final GetMemberAttendanceLogsUseCase _getLogsUseCase;
  final ExportMemberAttendanceLogsUseCase _exportLogsUseCase;

  TeamMemberAttendanceController(
    this._getLogsUseCase,
    this._exportLogsUseCase,
  );

  late final TeamMemberStatus member;

  final Rx<DateTimeRange> dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  ).obs;

  final RxList<AttendanceLog> logs = <AttendanceLog>[].obs;
  final RxInt totalLogs = 0.obs;
  final RxInt currentPage = 1.obs;
  final int itemsPerPage = 20;

  final RxBool isLoadingLogs = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLoadingExport = false.obs;
  final RxString selectedStatus = 'All'.obs;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is TeamMemberStatus) {
      member = Get.arguments as TeamMemberStatus;
      fetchLogs();
    }
    
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });

    _searchWorker = debounce(
      searchQuery,
      (String query) {
        if (query.length >= 3 || query.isEmpty) {
          fetchLogs();
        }
      },
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _searchWorker?.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  Future<void> fetchLogs({bool refresh = true}) async {
    if (refresh) {
      currentPage.value = 1;
      logs.clear();
      isLoadingLogs.value = true;
    } else {
      isLoadingMore.value = true;
    }
    
    final String? search = searchQuery.value.length >= 3 ? searchQuery.value : null;

    final result = await _getLogsUseCase(GetMemberAttendanceLogsUseCaseParams(
      uid: member.accountUid,
      fromDate: dateRange.value.start,
      toDate: dateRange.value.end,
      status: selectedStatus.value == 'All' ? null : selectedStatus.value,
      search: search,
      limit: itemsPerPage,
      offset: (currentPage.value - 1) * itemsPerPage,
    ));

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (data) {
        if (refresh) {
          logs.assignAll(data.logs);
        } else {
          logs.addAll(data.logs);
        }
        totalLogs.value = data.totalCount;
      },
    );
    
    if (refresh) {
      isLoadingLogs.value = false;
    } else {
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (logs.length < totalLogs.value && !isLoadingLogs.value && !isLoadingMore.value) {
      currentPage.value++;
      fetchLogs(refresh: false);
    }
  }

  void onStatusChanged(String? status) {
    if (status != null && status != selectedStatus.value) {
      selectedStatus.value = status;
      fetchLogs();
    }
  }

  Future<void> selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange.value,
    );

    if (picked != null) {
      dateRange.value = picked;
      fetchLogs();
    }
  }

  Future<void> exportLogs(String format) async {
    isLoadingExport.value = true;

    final result = await _exportLogsUseCase(ExportMemberAttendanceLogsUseCaseParams(
      uid: member.accountUid,
      format: format,
      fromDate: dateRange.value.start,
      toDate: dateRange.value.end,
      status: selectedStatus.value == 'All' ? null : selectedStatus.value,
      search: searchQuery.value.length >= 3 ? searchQuery.value : null,
    ));

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (fileUrl) async {
        final uri = Uri.parse(fileUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          AppSnackbar.success('Export successful. Opening file...');
        } else {
          AppSnackbar.destructive('Could not open the export file.');
        }
      },
    );

    isLoadingExport.value = false;
  }

  // Group logs by Month and Year (e.g. "April 2026")
  Map<String, List<AttendanceLog>> get groupedLogs {
    final Map<String, List<AttendanceLog>> groups = {};
    for (final log in logs) {
      // Create a key like "2026-04" for sorting, then we can format it in UI, or just use Month Year.
      // Better to use a sortable key, or rely on logs being already sorted by startAt descending.
      // Assuming logs are sorted descending by date.
      final key = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}';
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(log);
    }
    return groups;
  }
}
