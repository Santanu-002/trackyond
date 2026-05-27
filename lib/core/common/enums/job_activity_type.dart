enum JobActivityType {
  startedJob('started_job'),
  completedJob('completed_job'),
  reachedLocation('reached_location'),
  takeBreak('take_break'),
  breakOut('break_out'),
  sendLocation('send_location'),
  askLocation('ask_location'),
  askStatus('ask_status'),
  askStatusProofs('ask_status_proofs'),
  sendStatus('send_status'),
  cancelJob('cancel_job'),
  reopenJob('reopen_job'),
  jobCreated('job_created'),
  unknown('unknown');

  final String value;
  const JobActivityType(this.value);

  static JobActivityType fromString(String? val) {
    if (val == null) return JobActivityType.unknown;
    return switch (val.trim()) {
      'started_job' => JobActivityType.startedJob,
      'completed_job' => JobActivityType.completedJob,
      'reached_location' => JobActivityType.reachedLocation,
      'take_break' => JobActivityType.takeBreak,
      'break_out' => JobActivityType.breakOut,
      'send_location' => JobActivityType.sendLocation,
      'ask_location' => JobActivityType.askLocation,
      'ask_status' => JobActivityType.askStatus,
      'ask_status_proofs' => JobActivityType.askStatusProofs,
      'send_status' => JobActivityType.sendStatus,
      'cancel_job' => JobActivityType.cancelJob,
      'reopen_job' => JobActivityType.reopenJob,
      'job_created' => JobActivityType.jobCreated,
      _ => JobActivityType.unknown,
    };
  }

  String toJson() => value;
}
