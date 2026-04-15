import 'package:dio/dio.dart';
import '../api/api_endpoints.dart';

class NetworkClient {
  final Dio dio;

  NetworkClient(this.dio) {
    dio.options.baseUrl = ApiEndpoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
