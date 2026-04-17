import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:trackyond/features/auth/data/datasources/auth_datasource.dart';
import 'package:trackyond/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/auth/presentation/controllers/choose_role_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // Data layer
    Get.lazyPut<IAuthDataSource>(() => AuthDataSourceImpl(Get.find<Dio>()));
    Get.lazyPut<IAuthRepository>(() => AuthRepositoryImpl(Get.find<IAuthDataSource>()));

    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => ChooseRoleController());
  }
}
