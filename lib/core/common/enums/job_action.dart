enum JobAction {
  reached('reached'),
  startJob('start_job'),
  takeBreak('take_break'),
  resume('resume'),
  completeJob('complete_job'),
  sendLocation('send_location');

  final String value;
  const JobAction(this.value);

  static JobAction? fromString(String? action) {
    if (action == null) return null;
    return switch (action.toLowerCase()) {
      'reached' || 'reached_button' => JobAction.reached,
      'start_job' || 'start_job_button' || 'start job' => JobAction.startJob,
      'take_break' || 'take_break_button' || 'take a break' => JobAction.takeBreak,
      'resume' || 'resume_button' => JobAction.resume,
      'complete_job' || 'complete_job_button' || 'complete job' => JobAction.completeJob,
      'send_location' || 'send_location_button' || 'send location' => JobAction.sendLocation,
      _ => null,
    };
  }

  String get label {
    return switch (this) {
      JobAction.reached => 'Reached',
      JobAction.startJob => 'Start Job',
      JobAction.takeBreak => 'Take a Break',
      JobAction.resume => 'Resume',
      JobAction.completeJob => 'Complete Job',
      JobAction.sendLocation => 'Send Location',
    };
  }
}
