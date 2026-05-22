enum JobAction {
  // Worker Actions
  reached('reached'),
  startJob('start_job'),
  startJobWithCapturePhoto('start_job_with_capture_photo'),
  takeBreak('take_break'),
  completeJob('complete_job'),
  completeJobWithCapturePhoto('complete_job_with_capture_photo'),
  sendLocation('send_location'),

  // Owner/Admin Actions
  cancelJob('cancel_job'),
  reopenJob('reopen_job'),
  askLocation('ask_location'),
  askStatus('ask_status'),
  statusWithProofs('status_with_proofs');

  final String value;
  const JobAction(this.value);

  static JobAction? fromString(String? action) {
    if (action == null) return null;
    return switch (action.toLowerCase()) {
      'reached' || 'reached_button' => JobAction.reached,
      'start_job' || 'start_job_button' || 'start job' => JobAction.startJob,
      'start_job_with_capture_photo' => JobAction.startJobWithCapturePhoto,
      'take_break' || 'take_break_button' || 'take a break' => JobAction.takeBreak,
      'complete_job' || 'complete_job_button' || 'complete job' => JobAction.completeJob,
      'complete_job_with_capture_photo' => JobAction.completeJobWithCapturePhoto,
      'send_location' || 'send_location_button' || 'send location' => JobAction.sendLocation,
      'cancel_job' || 'cancel job' => JobAction.cancelJob,
      'reopen_job' || 'reopen job' => JobAction.reopenJob,
      'ask_location' || 'ask location' => JobAction.askLocation,
      'ask_status' || 'ask status' => JobAction.askStatus,
      'status_with_proofs' || 'status with proofs' => JobAction.statusWithProofs,
      _ => null,
    };
  }

  String get label {
    return switch (this) {
      JobAction.reached => 'Reached',
      JobAction.startJob => 'Start Job',
      JobAction.startJobWithCapturePhoto => 'Start Job',
      JobAction.takeBreak => 'Take a Break',
      JobAction.completeJob => 'Complete Job',
      JobAction.completeJobWithCapturePhoto => 'Complete Job',
      JobAction.sendLocation => 'Send Location',
      JobAction.cancelJob => 'Cancel Job',
      JobAction.reopenJob => 'Reopen Job',
      JobAction.askLocation => 'Ask Location',
      JobAction.askStatus => 'Ask Status',
      JobAction.statusWithProofs => 'Status with Proofs',
    };
  }
}
