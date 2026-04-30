import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';

abstract interface class ITeamRemoteDataSource {
  Future<ApiResponse<MemberProfileModel>> addTeamMember({
    required String name,
    required String phone,
    required String companyUid,
    required String designation,
    String? gender,
    String? imagePath,
  });

  Future<ApiResponse<List<MemberProfileModel>>> getTeamMembers();

  Future<ApiResponse<CompanyModel>> getCompany();
}

class TeamRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements ITeamRemoteDataSource {
  final Dio _dio;

  TeamRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<CompanyModel>> getCompany() async {
    return performApiRequest(
      _dio.get(ApiEndpoints.admin.company),
      (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<MemberProfileModel>> addTeamMember({
    required String name,
    required String phone,
    required String companyUid,
    required String designation,
    String? gender,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'memberName': name,
      'userPhoneNo': phone,
      'designation': designation,
      'gender': gender,
      'companyUid': companyUid,
    });

    if (imagePath != null) {
      formData.files.add(
        MapEntry('memberImage', await MultipartFile.fromFile(imagePath)),
      );
    }

    return performApiRequest(
      _dio.post(ApiEndpoints.admin.members, data: formData),
      (json) => MemberProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<MemberProfileModel>>> getTeamMembers() async {
    return performApiRequest(_dio.get(ApiEndpoints.admin.members), (json) {
      if (json is Map<String, dynamic> && json.containsKey('members')) {
        final members = json['members'] as List<dynamic>;

        return members
            .map<MemberProfileModel>((e) => MemberProfileModel.fromJson(e))
            .toList();
      }
      return <MemberProfileModel>[];
    });
  }
}
