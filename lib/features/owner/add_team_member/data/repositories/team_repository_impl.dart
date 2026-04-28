import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class TeamRepositoryImpl implements ITeamRepository {
  final ITeamRemoteDataSource _remoteDataSource;
  final UserService _userService;

  TeamRepositoryImpl({
    required ITeamRemoteDataSource remoteDataSource,
    required UserService userService,
  }) : _remoteDataSource = remoteDataSource,
       _userService = userService;

  @override
  Future<Either<AppFailure, MemberProfile>> addTeamMember({
    required String name,
    required String phone,
    required String companyUid,
    required String designation,
    String? imagePath,
    Gender? gender,
  }) async {
    try {
      final ApiResponse<MemberProfileModel> response = await _remoteDataSource
          .addTeamMember(
            name: name,
            phone: phone,
            companyUid: companyUid,
            designation: designation,
            gender: gender?.value,
            imagePath: imagePath,
          );

      return response.when(
        success: (success, message, data) {
          if (data != null) {
            return right(data.toEntity());
          }
          return left(ServerFailure('Member data missing in response'));
        },
        error: (success, message, data, statusCode) =>
            left(ServerFailure(message)),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<MemberProfile>>> getTeamMembers() async {
    try {
      final response = await _remoteDataSource.getTeamMembers();

      return response.when(
        success: (success, message, data) {
          final members = (data ?? []).map((e) => e.toEntity()).toList();
          return right(members);
        },
        error: (success, message, data, statusCode) =>
            left(ServerFailure(message)),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, CompanyEntity>> getCompany() async {
    try {
      // 1. Check local UserService
      final localCompany = _userService.getCompany();
      if (localCompany != null) {
        return right(localCompany.toEntity());
      }

      // 2. Fetch from remote
      final response = await _remoteDataSource.getCompany();

      return response.when(
        success: (success, message, data) async {
          if (data != null) {
            // Save to local service for future use
            await _userService.setCompany(data);
            return right(data.toEntity());
          }
          return left(ServerFailure('Company not found on server'));
        },
        error: (success, message, data, statusCode) =>
            left(ServerFailure(message)),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveOnboardingProgress({
    required bool completed,
  }) async {
    try {
      await _userService.setHasCompletedAddTeamMember(completed);
      return right(unit);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }
}
