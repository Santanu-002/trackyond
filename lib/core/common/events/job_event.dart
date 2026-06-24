import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/events/app_event.dart';

sealed class JobEvent extends AppEvent {
  const JobEvent();
}

class JobUpdatedEvent extends JobEvent {
  final JobEntity job;
  const JobUpdatedEvent(this.job);
}

class JobDeletedEvent extends JobEvent {
  final String jobId;
  const JobDeletedEvent(this.jobId);
}

class JobInsertedEvent extends JobEvent {
  final List<JobEntity> jobs;
  const JobInsertedEvent(this.jobs);
}


