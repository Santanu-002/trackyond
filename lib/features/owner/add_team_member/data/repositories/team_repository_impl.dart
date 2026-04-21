import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class TeamRepositoryImpl implements ITeamRepository {
  final TeamRemoteDataSource _remoteDataSource;
  final UserService _userService;

  TeamRepositoryImpl({
    required TeamRemoteDataSource remoteDataSource,
    required UserService userService,
  }) : _remoteDataSource = remoteDataSource,
       _userService = userService;

  @override
  Future<Either<AppFailure, Unit>> addTeamMember({
    required String name,
    required String phone,
    String? imagePath,
    Gender? gender,
  }) async {
    try {
      final company = _userService.getCompany();
      if (company == null) {
        return left(ServerFailure('Company information not found'));
      }

      final ApiResponse<dynamic> response = await _remoteDataSource
          .addTeamMember(
            name: name,
            phone: phone,
            companyUid: company.companyId,

            // default for now
            designation: 'worker',
            gender: gender?.value,
            imagePath: imagePath,
          );

      return response.when(
        success: (success, message, data) => right(unit),
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
