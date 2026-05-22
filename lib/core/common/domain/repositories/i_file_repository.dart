import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract class IFileRepository {
  Future<Either<AppFailure, String>> uploadFile({
    required File file,
    required String path,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  });
}
