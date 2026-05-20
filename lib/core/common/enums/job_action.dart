enum JobAction {
  reached('reached_button'),
  // TODO: Add start_job_button, take_break_button, resume_button, complete_job_button, send_location_button in the future when backend events are implemented
  startJob('start_job_button'),
  takeBreak('take_break_button'),
  resume('resume_button'),
  completeJob('complete_job_button'),
  sendLocation('send_location_button');

  final String value;
  const JobAction(this.value);

  static JobAction? fromString(String? action) {
    if (action == null) return null;
    return switch (action.toLowerCase()) {
      'reached_button' || 'reached' => JobAction.reached,
      'start_job_button' || 'start job' => JobAction.startJob,
      'take_break_button' || 'take a break' => JobAction.takeBreak,
      'resume_button' || 'resume' => JobAction.resume,
      'complete_job_button' || 'complete job' => JobAction.completeJob,
      'send_location_button' || 'send location' => JobAction.sendLocation,
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
