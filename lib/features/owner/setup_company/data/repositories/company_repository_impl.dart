import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/auth/data/models/user/user_model.dart';
import 'package:trackyond/features/owner/setup_company/data/datasources/owner_remote_data_source.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/setup_company_result_entity.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class CompanyRepositoryImpl implements ICompanyRepository {
  final OwnerRemoteDataSource _remoteDataSource;
  final UserService _userService;

  CompanyRepositoryImpl({
    required OwnerRemoteDataSource remoteDataSource,
    required UserService userService,
  }) : _remoteDataSource = remoteDataSource,
       _userService = userService;

  @override
  Future<Either<AppFailure, SetupCompanyResultEntity>> setupCompany({
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

  @override
  Future<void> updateSession({
    required MemberProfile profile,
    required bool isNewUser,
  }) async {
    final currentUser = _userService.getUser();
    if (currentUser != null) {
      final userModelWithUpdatedStatus = UserModel.fromEntity(
        currentUser,
      ).copyWith(isNewUser: isNewUser);

      await _userService.setUser(userModelWithUpdatedStatus);
    }
    await _userService.setProfile(MemberProfileModel.fromEntity(profile));
  }

  @override
  Future<void> saveCompany({
    required CompanyEntity company,
    required String phone,
    required int teamSize,
  }) async {
    await _userService.setCompany(
      CompanyModel(
        companyId: company.id,
        companyName: company.name,
        userPhoneNo: phone,
        teamSize: teamSize,
        createdAt: company.createdAt.toIso8601String(),
      ),
    );
  }
}
