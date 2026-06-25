import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/user/user_service.dart';
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
    required String ownerUid,
    required String phone,
    required int teamSize,
  }) async {
    try {
      final response = await _remoteDataSource.setupCompany(
        companyName: companyName,
        ownerName: ownerName,
        ownerUid: ownerUid,
        phone: phone,
        teamSize: teamSize,
      );

      return response.when(
        success: (_, message, data) {
          if (data != null) return Right(data);
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
  Future<Either<AppFailure, Unit>> updateUserDetails({
    required MemberProfile profile,
    required bool isNewUser,
  }) async {
    try {
      final currentUser = _userService.getUser();
      if (currentUser != null) {
        final userModelWithUpdatedStatus = currentUser.copyWith(
          isNewUser: isNewUser,
        );

        await _userService.setUser(userModelWithUpdatedStatus);
      }
      await _userService.setProfile(MemberProfileModel.fromEntity(profile));
      return right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveCompany({
    required CompanyEntity company,
  }) async {
    try {
      await _userService.setCompany(CompanyModel.fromEntity(company));
      return right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
