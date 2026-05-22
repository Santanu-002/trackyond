import 'dart:io';
import 'package:dio/dio.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';

abstract class IFileRemoteDataSource {
  Future<String> uploadFile({
    required File file,
    required String path,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  });
}

class FileRemoteDataSourceImpl with BaseRemoteDataSource implements IFileRemoteDataSource {
  final Dio _dio;

  FileRemoteDataSourceImpl(this._dio);

  @override
  Future<String> uploadFile({
    required File file,
    required String path,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'path': path,
    });

    final response = await performApiRequest(
      _dio.post(
        ApiEndpoints.common.upload,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      ),
      (json) => json as String,
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message);
    }
  }
}
