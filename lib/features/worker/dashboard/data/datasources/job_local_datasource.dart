import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/services/database/tables/job_table.dart';
import 'package:trackyond/core/services/database/database_service.dart';

abstract interface class IJobLocalDataSource {
  Future<void> saveJobs(List<JobModel> jobs);
  Future<List<JobModel>> getCachedJobs({String? status});
  Future<JobModel?> getCachedJob(String jobId);
  Future<void> updateCachedJobStatus(String jobId, String status);
  Future<void> clearJobs();
}

class JobLocalDataSourceImpl implements IJobLocalDataSource {
  final IDatabaseService _databaseService;

  JobLocalDataSourceImpl(this._databaseService);

  @override
  Future<void> saveJobs(List<JobModel> jobs) async {
    await _databaseService.transaction((txn) async {
      for (final job in jobs) {
        await txn.insert(
          JobTable.tableName,
          job.toDbMap(),
          conflictAlgorithm: DbConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<List<JobModel>> getCachedJobs({String? status}) async {
    final List<Map<String, dynamic>> maps;
    if (status != null) {
      maps = await _databaseService.query(
        JobTable.tableName,
        where: '${JobTable.columnNames.jobStatus} = ?',
        whereArgs: [status],
      );
    } else {
      maps = await _databaseService.query(JobTable.tableName);
    }

    return maps.map((map) => JobModel.fromDbMap(map)).toList();
  }

  @override
  Future<JobModel?> getCachedJob(String jobId) async {
    final maps = await _databaseService.query(
      JobTable.tableName,
      where: '${JobTable.columnNames.jobId} = ?',
      whereArgs: [jobId],
    );

    if (maps.isEmpty) return null;
    return JobModel.fromDbMap(maps.first);
  }

  @override
  Future<void> updateCachedJobStatus(String jobId, String status) async {
    await _databaseService.update(
      JobTable.tableName,
      {
        JobTable.columnNames.jobStatus: status,
        JobTable.columnNames.updatedAt: DateTime.now().toUtc().toIso8601String(),
      },
      where: '${JobTable.columnNames.jobId} = ?',
      whereArgs: [jobId],
    );
  }

  @override
  Future<void> clearJobs() async {
    await _databaseService.delete(JobTable.tableName);
  }
}
