import 'package:flutter/foundation.dart';

sealed class AppFailure {
  final String message;
  AppFailure(this.message) {
    debugPrint('\n❌ [FAILURE] $runtimeType: $message\n');
  }

  @override
  String toString() => message;
}

class ServerFailure extends AppFailure {
  ServerFailure(super.message);
}

class CacheFailure extends AppFailure {
  CacheFailure(super.message);
}

class NetworkFailure extends AppFailure {
  NetworkFailure(super.message);
}

class ValidationFailure extends AppFailure {
  ValidationFailure(super.message);
}

class AccessDeniedFailure extends AppFailure {
  AccessDeniedFailure(super.message);
}
