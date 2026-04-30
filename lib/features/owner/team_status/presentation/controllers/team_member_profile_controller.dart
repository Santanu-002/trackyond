import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/attendance_log.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/edit_member_profile_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_member_attendance_logs_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/mark_ex_employee_usecase.dart';

class TeamMemberProfileController extends GetxController {
  final GetMemberAttendanceLogsUseCase _getLogsUseCase;
  final EditMemberProfileUseCase _editProfileUseCase;
  final MarkExEmployeeUseCase _markExEmployeeUseCase;

  TeamMemberProfileController(
    this._getLogsUseCase,
    this._editProfileUseCase,
    this._markExEmployeeUseCase,
  );

  final Rx<DateTimeRange> dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  ).obs;

  final RxList<AttendanceLog> logs = <AttendanceLog>[].obs;
  final RxInt totalLogs = 0.obs;
  final RxInt currentPage = 1.obs;
  final int itemsPerPage = 10;
  
  final RxBool isLoadingLogs = false.obs;
  final RxBool isUpdatingProfile = false.obs;
  final RxString selectedStatus = 'All'.obs;

  late TeamMemberStatus member;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is TeamMemberStatus) {
      member = Get.arguments as TeamMemberStatus;
      fetchLogs();
    }
  }

  Future<void> fetchLogs({bool refresh = true}) async {
    if (refresh) {
      currentPage.value = 1;
      logs.clear();
    }
    
    isLoadingLogs.value = true;
    final result = await _getLogsUseCase(GetMemberAttendanceLogsUseCaseParams(
      uid: member.accountUid,
      fromDate: dateRange.value.start,
      toDate: dateRange.value.end,
      status: selectedStatus.value == 'All' ? null : selectedStatus.value,
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
    isLoadingLogs.value = false;
  }

  void loadMore() {
    if (logs.length < totalLogs.value && !isLoadingLogs.value) {
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

  Future<void> exportToPdf({Rect? sharePositionOrigin}) async {
    try {
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.interRegular();
      final boldFont = await PdfGoogleFonts.interBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text('Attendance Report - ${member.name}',
                  style: pw.TextStyle(font: boldFont, fontSize: 18)),
            ),
            pw.Text('Designation: ${member.designation ?? "-"}',
                style: pw.TextStyle(font: font)),
            pw.Text('Period: ${DateFormat('dd MMM yyyy').format(dateRange.value.start)} - ${DateFormat('dd MMM yyyy').format(dateRange.value.end)}',
                style: pw.TextStyle(font: font)),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(font: font),
              headers: ['Date', 'Check In', 'Check Out', 'Status', 'Location'],
              data: logs.map((log) => [
                DateFormat('dd MMM yyyy').format(log.date),
                DateFormat('hh:mm a').format(log.checkIn),
                log.checkOut != null ? DateFormat('hh:mm a').format(log.checkOut!) : '-',
                log.status,
                log.location ?? '-',
              ]).toList(),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/attendance_${member.name}.pdf');
      await file.writeAsBytes(bytes);
      
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Attendance Report - ${member.name}',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (e) {
      AppSnackbar.destructive('${AppStrings.teamMemberProfile.failToExportPdf}: $e');
    }
  }

  Future<void> exportToCsv({Rect? sharePositionOrigin}) async {
    try {
      String csvData = 'Date,Check In,Check Out,Status,Location\n';
      for (final log in logs) {
        final date = DateFormat('yyyy-MM-dd').format(log.date);
        final checkIn = DateFormat('HH:mm').format(log.checkIn);
        final checkOut = log.checkOut != null ? DateFormat('HH:mm').format(log.checkOut!) : '-';
        csvData += '$date,$checkIn,$checkOut,${log.status},${log.location ?? "-"}\n';
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/attendance_${member.name}.csv');
      await file.writeAsString(csvData);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Attendance Report - ${member.name}',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (e) {
      AppSnackbar.destructive('${AppStrings.teamMemberProfile.failToExportCsv}: $e');
    }
  }

  Future<void> exportToTxt({Rect? sharePositionOrigin}) async {
    try {
      String txtData = 'Attendance Report - ${member.name}\n';
      txtData += 'Designation: ${member.designation ?? "-"}\n';
      txtData += 'Period: ${DateFormat('dd MMM yyyy').format(dateRange.value.start)} - ${DateFormat('dd MMM yyyy').format(dateRange.value.end)}\n\n';
      txtData += 'Date | Check In | Check Out | Status | Location\n';
      txtData += '--------------------------------------------------\n';
      
      for (final log in logs) {
        final date = DateFormat('dd MMM yyyy').format(log.date);
        final checkInTime = DateFormat('hh:mm a').format(log.checkIn);
        final checkOutTime = log.checkOut != null ? DateFormat('hh:mm a').format(log.checkOut!) : '--:--';
        txtData += '$date | $checkInTime | $checkOutTime | ${log.status} | ${log.location ?? "-"}\n';
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/attendance_${member.name}.txt');
      await file.writeAsString(txtData);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Attendance Report - ${member.name}',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (e) {
      AppSnackbar.destructive('${AppStrings.teamMemberProfile.failToExportTxt}: $e');
    }
  }

  Future<void> editProfile(String designation, String phone) async {
    isUpdatingProfile.value = true;
    final profile = MemberProfile(
      accountUid: member.accountUid,
      userUid: member.userUid,
      name: member.name,
      phone: phone,
      designation: designation,
      gender: null, // Keep existing or add to UI
      image: member.image,
    );

    final result = await _editProfileUseCase(EditMemberProfileUseCaseParams(profile: profile));

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (updatedProfile) {
        AppSnackbar.success(AppStrings.teamMemberProfile.profileUpdated);
        // Update local member object if needed, or refresh list
        Get.back();
      },
    );
    isUpdatingProfile.value = false;
  }

  Future<void> markAsExEmployee() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(AppStrings.teamMemberProfile.confirmExEmployeeTitle),
        content: Text(AppStrings.teamMemberProfile.confirmExEmployeeMessage),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text(AppStrings.teamMemberProfile.cancel)),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppStrings.teamMemberProfile.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _markExEmployeeUseCase(MarkExEmployeeUseCaseParams(uid: member.accountUid));

      result.fold(
        (failure) => AppSnackbar.destructive(failure.message),
        (_) {
          AppSnackbar.success(AppStrings.teamMemberProfile.memberMarkedExEmployee);
          Get.back(); // Back to list
        },
      );
    }
  }
}
