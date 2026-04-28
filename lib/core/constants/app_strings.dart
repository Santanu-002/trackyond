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
}

class CommonStrings {
  const CommonStrings();

  String get appName => 'Trackyond';

  String get version => 'Trackyond v1.0.0';

  String get countryCode => '+91';

  String get termsAndPrivacy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy';

  String get agreementPrefix => 'By continuing, you agree to our ';

  String get termsOfService => 'Terms of Service';

  String get and => ' and ';

  String get privacyPolicy => 'Privacy Policy';
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

  String get requiredField => 'This field is required';

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

  String get cancelButton => 'Cancel';

  String get confirmButton => 'Confirm';

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

  String get doneButton => 'Done';

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

  String get discardConfirm => 'Discard';

  String get discardCancel => 'Cancel';

  String get companyNotLoaded => 'Company information not loaded yet';

  String get takePhoto => 'Take Photo';

  String get chooseFromGallery => 'Choose from Gallery';

  String get removePhoto => 'Remove Photo';
}

class OwnerDashboardStrings {
  const OwnerDashboardStrings();

  String get title => 'Dashboard';

  String get teamStatus => 'Team Status';

  String get stats => 'Stats';

  String get pending => 'Pending';

  String get progress => 'In Progress';

  String get completed => 'Completed';

  String get working => 'Working';

  String get notStarted => 'Not Started';

  String get statsTitle => 'Task Statistics';

  String get recentJobs => 'Recent Jobs';

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

  String get cancel => 'Cancel';

  String get locationRequired =>
      'Location access required for attendance tracking.';

  String get workDayStarted => 'Work Day Started';

  String get startMyDay => 'Start my day';

  String get endMyDay => 'End my day';

  String get fetchingLocation => 'Fetching location...';

  String get recentJobs => 'Recent Jobs';

  String jobHash(int id) => 'Job #$id';

  String completedTime(String time) => '$time • Completed';

  String get dayEnded => 'Day Ended';
}

class WorkerProfileStrings {
  const WorkerProfileStrings();

  String get title => 'My Profile';
}
