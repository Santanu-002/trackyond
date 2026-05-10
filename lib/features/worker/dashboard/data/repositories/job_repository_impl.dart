import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_datasource.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';

class JobRepositoryImpl implements IJobRepository {
  final IJobDataSource _dataSource;

  JobRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, List<JobEntity>>> getAssignedJobs({
    int limit = 20,
    int offset = 0,
    String? status,
  }) async {
    final response = await _dataSource.getAssignedJobs(
      limit: limit,
      offset: offset,
      status: status,
    );

    return response.when(
      success: (success, message, data) =>
          right(data?.map((e) => e.toEntity()).toList() ?? []),
      error: (success, message, data, statusCode) =>
          left(ServerFailure(message)),
    );
  }
}
