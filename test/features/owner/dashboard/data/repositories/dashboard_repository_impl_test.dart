import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/features/owner/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:trackyond/features/owner/dashboard/data/models/owner_dashboard_model.dart';
import 'package:trackyond/features/owner/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:trackyond/core/common/models/job_model.dart';

class MockDashboardRemoteDataSource extends Mock implements IDashboardRemoteDataSource {}

void main() {
  late DashboardRepositoryImpl repository;
  late MockDashboardRemoteDataSource mockRemoteDataSource;

setUp(() {
    mockRemoteDataSource = MockDashboardRemoteDataSource();
    repository = DashboardRepositoryImpl(mockRemoteDataSource);
  });

  group('getOwnerDashboard', () {
    final tDashboardModel = OwnerDashboardModel(
      teamMembersStatus: const [],
      jobCounts: const JobCountsModel(pending: 5, inProgress: 2, completed: 10, cancelled: 0),
      recentJobs: [
        JobModel(
          jobId: '123',
          jobTitle: 'Test Job',
          customerName: 'Customer',
          customerPhone: '1234567890',
          status: 'pending',
          requirePhotoOnStart: false,
          requirePhotoOnComplete: false,
          captureLocation: true,
          createdAt: DateTime.parse('2026-05-10T07:02:57Z'),
        ),
      ],
    );

    test('should return OwnerDashboardData when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getOwnerDashboard()).thenAnswer(
        (_) async => ApiResponse.success(
          success: true,
          message: 'Success',
          data: tDashboardModel,
        ),
      );

      // act
      final result = await repository.getOwnerDashboard();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) {
          expect(data.jobCounts.pending, 5);
          expect(data.recentJobs.length, 1);
          expect(data.recentJobs.first.jobTitle, 'Test Job');
        },
      );
      verify(() => mockRemoteDataSource.getOwnerDashboard()).called(1);
    });

    test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(() => mockRemoteDataSource.getOwnerDashboard()).thenAnswer(
        (_) async => const ApiResponse.error(
          success: false,
          message: 'Server Error',
        ),
      );

      // act
      final result = await repository.getOwnerDashboard();

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRemoteDataSource.getOwnerDashboard()).called(1);
    });
  });
}
