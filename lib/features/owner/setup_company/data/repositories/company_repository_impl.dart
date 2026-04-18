import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/setup_company/data/datasources/owner_remote_data_source.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/company_entity.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class CompanyRepositoryImpl implements ICompanyRepository {
  final OwnerRemoteDataSource _remoteDataSource;

  CompanyRepositoryImpl({required OwnerRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<AppFailure, CompanyEntity>> setupCompany({
    required String companyName,
    required String ownerName,
    required String phone,
    required int teamSize,
  }) async {
    try {
      final ApiResponse response = await _remoteDataSource.setupCompany(
        companyName: companyName,
        ownerName: ownerName,
        phone: phone,
        teamSize: teamSize,
      );

      return response.when(
        success: (_, message, data) {
          if (data != null) return Right(data.toEntity());
          return Left(ServerFailure(message));
        },
        error: (success, message, data, statusCode) {
          return Left(ServerFailure(message));
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
