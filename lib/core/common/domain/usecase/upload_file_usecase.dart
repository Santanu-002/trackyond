import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/domain/repositories/i_file_repository.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';

class UploadFileParams {
  final File file;
  final String path;
  final CancelToken? cancelToken;
  final void Function(int, int)? onSendProgress;

  UploadFileParams({
    required this.file,
    required this.path,
    this.cancelToken,
    this.onSendProgress,
  });
}

class UploadFileUseCase implements BaseUseCase<String, UploadFileParams> {
  final IFileRepository _repository;

  UploadFileUseCase(this._repository);

  @override
  Future<Either<AppFailure, String>> call(UploadFileParams params) {
    return _repository.uploadFile(
      file: params.file,
      path: params.path,
      cancelToken: params.cancelToken,
      onSendProgress: params.onSendProgress,
    );
  }
}
