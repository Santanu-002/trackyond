import 'package:get/get.dart';
import 'package:trackyond/features/owner/setup_company/data/datasources/owner_remote_data_source.dart';
import 'package:trackyond/features/owner/setup_company/data/repositories/company_repository_impl.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';
import 'package:trackyond/features/owner/setup_company/domain/usecases/setup_company_usecase.dart';
import 'package:trackyond/features/owner/setup_company/presentation/controllers/setup_company_controller.dart';

class SetupCompanyBinding extends Bindings {
  @override
  void dependencies() {
    // Data Layer
    Get.lazyPut<OwnerRemoteDataSource>(
      () => OwnerRemoteDataSourceImpl(dio: Get.find()),
    );
    Get.lazyPut<ICompanyRepository>(
      () => CompanyRepositoryImpl(remoteDataSource: Get.find()),
    );

    // Domain Layer (Use Cases)
    Get.lazyPut<SetupCompanyUseCase>(
      () => SetupCompanyUseCase(Get.find()),
    );

    // Presentation Layer (Controllers)
    Get.lazyPut<SetupCompanyController>(
      () => SetupCompanyController(
        setupCompanyUseCase: Get.find<SetupCompanyUseCase>(),
      ),
    );
  }
}
