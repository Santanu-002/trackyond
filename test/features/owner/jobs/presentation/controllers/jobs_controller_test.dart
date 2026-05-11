import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/get_jobs_use_case.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_stats_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_options_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_pagination_entity.dart';

class MockGetJobsUseCase extends Mock implements GetJobsUseCase {}

class MockGetTeamStatusUseCase extends Mock implements GetTeamStatusUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late JobsController controller;
  late MockGetJobsUseCase mockGetJobsUseCase;
  late MockGetTeamStatusUseCase mockGetTeamStatusUseCase;

  setUp(() {
    mockGetJobsUseCase = MockGetJobsUseCase();
    mockGetTeamStatusUseCase = MockGetTeamStatusUseCase();

    // Default success response
    when(() => mockGetJobsUseCase(any())).thenAnswer(
      (_) async => const Right([]),
    );

    when(() => mockGetTeamStatusUseCase(any())).thenAnswer(
      (_) async => const Right(TeamStatusEntity(
        members: [],
        stats: TeamStatusStatsEntity(total: 0, working: 0, notStarted: 0),
        options: TeamStatusOptionsEntity(),
        pagination: TeamStatusPaginationEntity(limit: 50, totalItems: 0),
      )),
    );

    controller = JobsController(
      getJobsUseCase: mockGetJobsUseCase,
      getTeamStatusUseCase: mockGetTeamStatusUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(GetJobsParams());
    registerFallbackValue(GetTeamStatusParams());
  });

  group('JobsController', () {
    test('should init controller and fetch initial data', () async {
      // act
      controller.onInit();

      // assert
      expect(controller.jobs, isEmpty);
      // It starts loading immediately
      verify(() => mockGetJobsUseCase(any())).called(1);
    });

    test('should update status and trigger refetch', () async {
      // arrange
      controller.onInit();
      reset(mockGetJobsUseCase);
      when(() => mockGetJobsUseCase(any())).thenAnswer(
        (_) async => const Right([]),
      );
      
      // act
      controller.setStatus(JobStatus.completed);

      // assert
      expect(controller.isStatusSelected(JobStatus.completed), isTrue);
      expect(controller.isStatusSelected(JobStatus.pending), isFalse);
      verify(() => mockGetJobsUseCase(any())).called(1);
    });
  });
}
