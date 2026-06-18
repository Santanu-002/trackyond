class AppStrings {
  const AppStrings._();

  static const common = CommonStrings();
  static const chooseRole = ChooseRoleStrings();
  static const sendOtp = SendOtpStrings();
  static const verifyOtp = VerifyOtpStrings();
  static const setupCompany = SetupCompanyStrings();
  static const chooseTeamSize = ChooseTeamSizeStrings();
  static const addTeamMember = AddTeamMemberStrings();
  static const ownerDashboard = OwnerDashboardStrings();
  static const workerDashboard = WorkerDashboardStrings();
  static const workerProfile = WorkerProfileStrings();
  static const drawer = DrawerStrings();
  static const teamStatus = TeamStatusStrings();
  static const teamMemberProfile = TeamMemberProfileStrings();
  static const teamMemberAttendance = TeamMemberAttendanceStrings();
  static const createJob = CreateJobStrings();
  static const jobs = JobsStrings();
  static const jobDetails = JobDetailsStrings();
  static const notifications = NotificationsStrings();
  static const jobChat = JobChatStrings();
  static const camera = CameraStrings();
}

class NotificationsStrings {
  const NotificationsStrings();

  String get appBarTitle => 'Notifications';
  String get noNotifications => 'No notifications yet';
  String get clearAll => 'Clear All';
  String get markAllAsRead => 'Mark all as read';
  String get markAsRead => 'Mark as Read';
  String get delete => 'Delete';
  String get copyDetails => 'Copy Details';
  String get notificationDetails => 'Notification Details';
  String get noDetailsAvailable => 'No details available';
  String get defaultNotificationTitle => 'Notification';
  String get userRoleNotFound => 'User role not found';
  String get fcmTokenNotFound => 'FCM token not found';
  String get titleLabel => 'Title';
  String get messageLabel => 'Message';
  String get dateLabel => 'Date';
  String get dateTimeFormat => 'MMM d, y h:mm a';
  String selectedCount(int count) => '$count  Selected';

  // Filter & sort labels
  String get filterAll => 'All';
  String get filterUnread => 'Unread';
  String get filterRead => 'Read';
  String get sortNewest => 'Newest';
  String get sortOldest => 'Oldest';

  // Date group headers
  String get groupToday => 'Today';
  String get groupYesterday => 'Yesterday';
  String groupDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class CommonStrings {
  const CommonStrings();

  String get appName => 'Trackyond';

  String get version => 'Trackyond v1.0.0';

  String get loading => 'Loading...';

  String get countryCode => '+91';

  String get agreementPrefix => 'By continuing, you agree to our ';

  String get termsOfService => 'Terms of Service';

  String get and => ' and ';

  String get privacyPolicy => 'Privacy Policy';

  String get requiredField => 'This field is required';

  String get cancel => 'Cancel';

  String get confirm => 'Confirm';

  String get done => 'Done';

  String get save => 'Save';

  String get edit => 'Edit';

  String get searchPlaceholder => 'Search...';

  String get noResultsFound => 'No results found';

  String get copied => 'Copied to clipboard';

  String get underDevelopment => 'Feature under development';
}

class ChooseRoleStrings {
  const ChooseRoleStrings();

  String get title => 'Precision Management';

  String get subtitle =>
      "Select your role to continue with Trackyond's curated workflow.";

  String get loginEmployee => 'Login as Employee';

  String get loginCompany => 'Login as Company';
}

class SendOtpStrings {
  const SendOtpStrings();

  String get ownerTitle => 'Company Portal';

  String get ownerSubtitle =>
      'Enter your company phone number to access the dashboard.';

  String get workerTitle => 'Employee Access';

  String get workerSubtitle =>
      'Enter your registered phone number to log into your account.';

  String get phoneLabel => 'Phone Number';

  String get phoneHint => '00000 00000';

  String get buttonText => 'Get Verification Code';

  String get invalidPhone => 'Please enter a valid 10-digit phone number';

  String get otpResent => 'OTP resent successfully';

  String get accessDenied => 'Access Denied';

  String get employeeAlreadyExists =>
      'This number is already registered as an employee.';

  String get tryLoginAsEmployee => 'Try logging in as an employee instead.';

  String get changeRoleAction => 'Login as an employee';
}

class VerifyOtpStrings {
  const VerifyOtpStrings();

  String get title => 'Verify OTP';

  String get buttonText => 'Verify & Continue';

  String get resendText => "Didn't receive code?";

  String resendIn(String time) => 'Resend in $time';

  String get resendButton => 'Resend Now';

  String get invalidOtp => 'Invalid OTP. Please try again.';

  String get incompleteOtp => 'Please enter the complete 6-digit code.';

  String get loginSuccess => 'Successfully logged in!';

  String subtitle(String phone) =>
      'We have sent a 6-digit verification code to $phone';
}

class SetupCompanyStrings {
  const SetupCompanyStrings();

  String get appBarTitle => 'Set Up Company';

  String get title => 'Business Profile';

  String get subtitle =>
      'Provide your business details to complete the registration process.';

  String get companyNameLabel => 'Company Name';

  String get companyNameHint => 'Enter your company name';

  String get yourNameLabel => 'Your Name';

  String get yourNameHint => 'Enter your full name';

  String get phoneNumberLabel => 'Phone Number';

  String get continueButton => 'Complete Setup';

  String get setupSuccess => 'Company set up successfully!';
}

class ChooseTeamSizeStrings {
  const ChooseTeamSizeStrings();

  String get appBarTitle => 'Your Team Size';

  String get title => 'Select your team size';

  String get subtitle => 'You can change this anytime';

  String get freeBanner => 'Start with 5 users FREE for 7 days';

  String get noCreditCard => 'No credit card required';

  String get smallTeamTitle => '5 users';

  String get smallTeamSub => 'Perfect for small teams';

  String get growingTeamTitle => '10 users';

  String get growingTeamSub => 'Growing teams';

  String get mediumTeamTitle => '20 users';

  String get mediumTeamSub => 'Medium teams';

  String get customTeamTitle => 'Custom';

  String get customTeamSub => 'Large teams';

  String get customTitle => 'Custom Team Size';

  String get customSubtitle => 'Enter the exact number of users in your team';

  String get teamSizeLabel => 'Number of Users';

  String get teamSizeHint => 'e.g. 50';

  String get invalidTeamSize => 'Please enter a valid number (1 - 999,999)';

  String get finishButton => 'Finish Setup';
}

class AddTeamMemberStrings {
  const AddTeamMemberStrings();

  String get appBarTitle => 'Add Team Member';

  String get title => 'Build Your Team';

  String get subtitle =>
      'Add your first team member to start collaborating and tracking together.';

  String get memberNameLabel => 'Member Name';

  String get memberNameHint => "Enter team member's name";

  String get phoneLabel => 'Phone Number';

  String get phoneHint => '00000 00000';

  String get roleLabel => 'Select Role';

  String get roleHint => 'Choose a role';

  String get addButton => 'Add Member';

  String get skipButton => 'Skip';

  String get continueButton => 'Go to Dashboard';

  String get successMessage => 'Member added successfully!';

  String get addNewMemberTile => 'Add new member';

  String get noMembersYet => 'No members added yet';

  String get genderLabel => 'Gender';

  String get genderMale => 'Male';

  String get genderFemale => 'Female';

  String get genderOther => 'Other';

  String get designationLabel => 'Designation';

  String get designationHint => 'e.g. Project Manager';

  String get createButton => 'Create Member';

  String get discardTitle => 'Discard Changes?';

  String get discardMessage =>
      'You have unsaved changes in the form. Are you sure you want to discard them?';

  String get companyNotLoaded => 'Company information not loaded yet';

  String get takePhoto => 'Take Photo';

  String get chooseFromGallery => 'Choose from Gallery';

  String get removePhoto => 'Remove Photo';

  String get nameRequired => 'Member name is required';

  String get phoneRequired => 'Phone number is required';

  String get phoneInvalid => 'Please enter a valid 10-digit phone number';

  String get designationRequired => 'Designation is required';

  String get discardConfirm => 'Discard';

  String get discardCancel => 'Cancel';

  String get doneButton => 'Done';
}

class OwnerDashboardStrings {
  const OwnerDashboardStrings();

  String get title => 'Dashboard';

  String get teamStatus => 'Team Status';

  String get stats => 'Stats';

  String get pending => 'Pending';
  String get progress => 'In Progress';
  String get completed => 'Completed';
  String get cancelled => 'Cancelled';

  String get working => 'Working';

  String get notStarted => 'Not Started';

  String get statsTitle => 'Task Statistics';

  String get recentJobs => 'Recent Jobs';
  String get noRecentJobs => 'No recent jobs found';
  String get viewAll => 'View All';
}

class DrawerStrings {
  const DrawerStrings();

  String get dashboard => 'Dashboard';

  String get jobs => 'Jobs';

  String get team => 'Team';

  String get activity => 'Activity';

  String get billing => 'Billing';

  String get settings => 'Settings';

  String get logout => 'Logout';
}

class WorkerDashboardStrings {
  const WorkerDashboardStrings();

  String get title => 'Dashboard';

  String welcome(String name) => 'Welcome, $name!';

  String greetingWithName(String greeting, String name) => '$greeting, $name!';

  String get message => 'Your login was successful.';

  String get goBack => 'Go Back';

  String get goodMorning => 'Good Morning';

  String get goodAfternoon => 'Good Afternoon';

  String get goodEvening => 'Good Evening';

  String get permissionDenied => 'Permission Denied';

  String get locationPermissionRequired =>
      'Location permission is required to start your day.';

  String get locationDisabled => 'Location Disabled';

  String get locationDisabledMessage =>
      'Please enable location services to proceed.';

  String get openLocationSettings => 'Open Location Settings';

  String get openAppSettings => 'Open Settings';

  String get locationRequired =>
      'Location access required for attendance tracking.';

  String get workDayStarted => 'Work Day Started';

  String get startMyDay => 'Start my day';

  String get endMyDay => 'End my day';

  String get fetchingLocation => 'Fetching location...';

  String get checkingPermissions => 'Checking permissions...';

  String get acquiringGps => 'Acquiring GPS signal...';

  String get resolvingAddress => 'Resolving your address...';

  String get syncingWithServer => 'Syncing with server...';

  String get endingSession => 'Ending session...';

  String get jobStatsTitle => 'Job Stats';

  String get today => 'Today';
  String get overall => 'Overall';
  String get pending => 'Pending';
  String get inProgress => 'In Progress';
  String get completed => 'Completed';
  String get cancelled => 'Cancelled';

  String get completedToday => 'Completed Today';

  String get totalAssigned => 'Total Assigned';

  String get recentJobs => 'Recent Jobs';

  String get viewAll => 'View All';

  String get noRecentJobs => 'No recent jobs';

  String jobHash(int id) => 'Job #$id';

  String completedTime(String time) => '$time • Completed';

  String get dayEnded => 'Day Ended';

  String get workDayEnded => 'Work Day Ended';
}

class WorkerProfileStrings {
  const WorkerProfileStrings();

  String get title => 'My Profile';
}

class TeamStatusStrings {
  const TeamStatusStrings();

  String get title => 'Team Status';
  String get searchHint => 'Search members...';
  String get searchByAll => 'All';
  String get searchByName => 'Name';
  String get searchByDesignation => 'Designation';
  String get searchByPhone => 'Phone';
  String get noMembersFound => 'No members found';
  String get noMatchingMembers => 'No matching members found';
  String get newest => 'Newest';
  String get oldest => 'Oldest';
  String get working => 'Working';
  String get inactive => 'Inactive';
  String get total => 'Total';
}

class TeamMemberProfileStrings {
  const TeamMemberProfileStrings();

  String get todayStatus => "Today's Status";
  String get activeSince => 'Active Since';
  String get attendanceLogs => 'Attendance Logs';
  String get noLogsFound => 'No logs found for this period';
  String get manageMember => 'Manage Member';
  String get editProfile => 'Edit Profile';
  String get markAsExEmployee => 'Mark as Ex-Employee';
  String get exportLogs => 'Export Logs';
  String get exportAsPdf => 'Export as PDF';
  String get exportAsCsv => 'Export as CSV';
  String get exportAsTxt => 'Export as TXT';
  String get confirmExEmployeeTitle => 'Confirm';
  String get confirmExEmployeeMessage =>
      'Are you sure you want to mark this member as an ex-employee? This action cannot be undone.';
  String get profileUpdated => 'Profile updated successfully';
  String get memberMarkedExEmployee => 'Member marked as ex-employee';
  String get failToExportPdf => 'Failed to export PDF';
  String get failToExportCsv => 'Failed to export CSV';
  String get failToExportTxt => 'Failed to export TXT';
  String get designationLabel => 'Designation';
  String get phoneLabel => 'Phone';
  String get profileDetails => 'Profile Details';
  String get memberInfo => 'Member Information';
  String get contactInfo => 'Contact Information';
  String get viewAllLogs => 'View All Logs';
  String get searchLocation => 'Search by location...';
  String get todayAttendance => "Today's Attendance";
  String get clockIn => 'Clock In';
  String get clockOut => 'Clock Out';
  String get workHours => 'Work Hours';
  String get location => 'Location';
  String get noAttendanceRecord => 'No attendance session recorded for today.';
  String get call => 'Call';
  String get message => 'Message';
  String get logs => 'Logs';
  String get customNotifications => 'Custom Notifications';
  String get accessPermissions => 'Access Permissions';
  String get deactivateMember => 'Deactivate Member';
}

class TeamMemberAttendanceStrings {
  const TeamMemberAttendanceStrings();

  String get title => 'Attendance History';
  String get searchHint => 'Search by location...';
  String get selectDateRange => 'Select Date Range';
  String get filterStatus => 'Filter Status';
  String get export => 'Export';
}

class CreateJobStrings {
  const CreateJobStrings();

  String get appBarTitle => 'Create New Job';
  String get workLabel => 'Work / Job*';
  String get workHint => 'e.g. AC not cooling';
  String get customerNameLabel => 'Customer Name*';
  String get customerNameHint => 'Enter customer name';
  String get phoneLabel => 'Phone Number*';
  String get phoneHint => '0000 0000';
  String get addressLabel => 'Address';
  String get addressHint => 'Enter address (optional)';
  String get assignWorkerLabel => 'Assign Worker';
  String get assignWorkerHint => 'Select worker';
  String get jobRequirementsTitle => 'Job Requirements';
  String get photoOnCompletionTitle => 'Require photo on completion';
  String get photoOnCompletionSubtitle => 'Worker must take photo before completing job';
  String get captureLocationTitle => 'Capture location';
  String get captureLocationSubtitle => 'Location will be recorded on actions';
  String get photoOnStartTitle => 'Require photo when starting work';
  String get photoOnStartSubtitle => 'Worker must take photo before starting';
  String get createJobButton => 'Create New Job';
  String get membersLabel => 'Members';
  String get assignWorkerWarning => 'Please assign a worker to this job.';
  String get createJobSuccess => 'Job created successfully.';
}

class JobsStrings {
  const JobsStrings();

  String get appBarTitle => 'Jobs';
  String get noJobsFound => 'No jobs found';
  String get allJobs => 'All Jobs';
  String get searchHint => 'Search jobs...';
  String get sortBy => 'Sort By';
  String get filter => 'Filter';
  String get today => 'Today';
  String get thisWeek => 'This Week';
  String get thisMonth => 'This Month';
  String get last3Months => 'Last 3 Months';
  String get pending => 'Pending';
  String get assigned => 'Pending';
  String get inProgress => 'In Progress';
  String get completed => 'Completed';
  String get cancelled => 'Cancelled';
  String get date => 'Date';
  String get status => 'Status';
  String get members => 'Members';
  String get noJobsMatchingFilters => 'No jobs match your current filters';
  String get clearAllFilters => 'Clear All Filters';
  String get clear => 'Clear';
  String get searchInAllDates => 'Search in all dates';
  String noSearchFound(String query) => 'No results found for "$query"';
  String get startDateAfterEndDateError => 'Start date cannot be after end date';
  String get selectStatuses => 'Select Statuses';
  String get filterLogic => 'Filter Logic';
  String get summary => 'Summary';
  String get assignTo => 'Assign To';
  String get resetAll => 'Reset All';
  String get applyFilters => 'Apply Filters';
  String get noFiltersApplied => 'No filters applied';
  String get chooseDateRange => 'Choose Date Range';
  String get dateRange => 'Date Range';
  String get searchByAll => 'All';
  String get searchByTitle => 'Title';
  String get searchByCustomer => 'Customer';
  String get searchByAddress => 'Address';
  String get searchByWorker => 'Worker';
  String get sortDateCreated => 'Date Created';
  String get sortJobTitle => 'Job Title';
  String get sortStatus => 'Status';
  String get sortCustomerName => 'Customer Name';
  String get sortWorkerName => 'Worker Name';
  String get sortAssignedAt => 'Assigned At';
  String get sortCompletedAt => 'Completed At';
  String get sortStartedAt => 'Started At';
  String get sortUpdatedAt => 'Updated At';
}

class JobDetailsStrings {
  const JobDetailsStrings();

  String get appBarTitle => 'Job Details';
  String get customerInfo => 'Customer Information';
  String get jobInfo => 'Job Information';
  String get assignmentInfo => 'Assignment';
  String get status => 'Status';
  String get customerName => 'Customer Name';
  String get phone => 'Phone';
  String get address => 'Address';
  String get work => 'Work';
  String get assignedTo => 'Assigned To';
  String get unassigned => 'Unassigned';
  String get scheduledAt => 'Scheduled At';
  String get createdAt => 'Created At';
  String get requirements => 'Requirements';
  String get photoRequiredOnStart => 'Photo required on start';
  String get photoRequiredOnCompletion => 'Photo required on completion';
  String get locationTrackingEnabled => 'Location tracking enabled';
  String get jobId => 'Job ID';
}

class JobChatStrings {
  const JobChatStrings();

  String get newMessages => 'New Messages';
  String get jobUpdateBannerTitle => 'Job Update';
  String get timeFormat => 'hh:mm a';
  String get justNow => 'Just now';
  String jobSubtitle(String jobId, String status) => 'Job #$jobId • $status';
  String get somethingWentWrong => 'Something went wrong';
  String get retry => 'Retry';
  String get attendanceRequired => 'You must start your day before performing this action.';
  
  String get activityJobAssigned => 'Job Assigned';
  String get activityReachedSite => 'Reached Site';
  String get activityJobStarted => 'Job Started';
  String get activityJobCompleted => 'Job Completed';
  String get activityOnBreak => 'On Break';
  String get activityBreakEnded => 'Break Ended';
  String breakDuration(String duration) => 'Break Duration: $duration';
  String get activityLocationShared => 'Location Shared';
  String get activityLocationRequested => 'Location Requested';
  String get activityStatusRequested => 'Status Requested';
  String get activityStatusProofsRequested => 'Status & Proofs Requested';
  String get activityJobCancelled => 'Job Cancelled';
  String get activityJobReopened => 'Job Reopened';
  String get activityUpdate => 'Activity Update';
  String get activityDefaultReached => "I've reached the location";
  String get viewOnGoogleMaps => 'View on Google Maps';
  String get activityDefaultMessage => 'Performed action';
  String get selected => 'selected';
  String get messagesCopied => 'Messages copied to clipboard';
  String get addCaptionHint => 'Add a caption...';
  String get jobIdPrefix => 'Job #';
  String uploadingPhotoProgress(String percentage) => 'Uploading Photo: $percentage%';
  String get sendingUpdate => 'Sending update...';
  String get processingPhoto => 'Processing photo...';
  String get uploadingPhoto => 'Uploading photo...';
  String get processingVideo => 'Processing video...';
  String get uploadingVideo => 'Uploading video...';
  String get processingDoc => 'Processing document...';
  String get uploadingDoc => 'Uploading document...';
  String get checkingPermissions => 'Checking permissions...';
  String get acquiringGPS => 'Acquiring GPS...';
  String get resolvingAddress => 'Resolving Address...';
  String get syncingWithServer => 'Syncing with server...';
  String get statusProofDefaultCaption => 'Uploaded a status update with photo proof.';
  String get statusUpdateSuccess => 'Status update sent successfully.';
  String get photoRequired => 'Photo is required for this action.';
  String get waitingForPhoto => 'Waiting for photo...';
  
  // Cropping & Media Preview Strings
  String pdfPageCount(int count) => count == 1 ? '1 page' : '$count pages';
  String get onlyPdfsAllowed => 'Only PDF files are allowed';
  String get messageRemovedByAdmin => 'This message was removed by Admin';
  String get messageRemoved => 'This message was removed';
  String get deleteForMe => 'Delete for me';
  String get deleteForEveryone => 'Delete for everyone';
  String get deleteMessagesTitle => 'Delete Message?';
  String deleteMessagesPrompt(int count) => count == 1
      ? 'Are you sure you want to delete this message?'
      : 'Are you sure you want to delete these $count messages?';
  String get cropImageSuccess => 'Image cropped successfully!';
  String get cropImageFailed => 'Failed to crop image. Please try again.';
  String get cropOriginalFileNotFound => 'Original file does not exist.';
  String get cropDecodeFailed => 'Failed to decode image.';
  String get cropProcessing => 'Processing Image...';
  String get cropSending => 'Sending Media...';
  String get cropActionFlip => 'Flip';
  String get cropActionRotateLeft => 'Left';
  String get cropActionRotateRight => 'Right';
  String get cropPresetOriginal => 'Original';
  String get cropPresetFree => 'Free';
  String get cropImageDeleted => 'Image removed from preview.';
  String get trimmingVideo => 'Trimming video...';
  String get trimmingVideos => 'Trimming videos...';
  String get trimPhasePreparing => 'Preparing...';
  String get trimPhaseFinalizing => 'Finalizing...';
  String trimmingVideoOf(int current, int total) =>
      total == 1 ? 'Trimming video...' : 'Trimming $current of $total...';
  
  // Image Viewer Strings
  String get reply => 'Reply';
  String get saveImageSuccess => 'Image saved to Downloads folder!';
  String get saveImageFailed => 'Failed to download image.';
  String get saveVideoSuccess => 'Video saved to Downloads folder!';
  String get saveVideoFailed => 'Failed to download video.';
  String get saveDirectoryNotFound => 'Failed to find storage directory.';
  String get shareImageFailed => 'Failed to share: Image data could not be fetched.';
  String get shareError => 'Error sharing image: ';
  String get saveError => 'Error saving image: ';
}

class CameraStrings {
  const CameraStrings();

  String get noCameraFound => 'No camera found on this device';
  String get failedToAccessCameras => 'Failed to access cameras';
  String get failedToStartCamera => 'Failed to start camera preview';
  String get failedToSetFlashMode => 'Failed to change flash mode';
  String get failedToCapturePhoto => 'Failed to capture photo';
}
