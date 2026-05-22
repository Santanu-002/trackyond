import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/data/datasources/file_remote_datasource.dart';
import 'package:trackyond/core/common/domain/repositories/i_file_repository.dart';
import 'package:trackyond/core/exception/api_exception.dart';
import 'package:trackyond/core/exception/app_failures.dart';

class FileRepositoryImpl implements IFileRepository {
  final IFileRemoteDataSource _remoteDataSource;

  FileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, String>> uploadFile({
    required File file,
    required String path,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final response = await _remoteDataSource.uploadFile(
        file: file,
        path: path,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return right(response);
    } on ApiException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
