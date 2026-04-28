import 'package:dio/dio.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/owner/setup_company/data/models/company_response_model.dart';

abstract interface class  OwnerRemoteDataSource {
  Future<ApiResponse<CompanyResponseModel>> setupCompany({
    required String companyName,
    required String ownerName,
    required String ownerUid,
    required String phone,
    required int teamSize,
  });
}

class OwnerRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements OwnerRemoteDataSource {
  final Dio _dio;

  OwnerRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<CompanyResponseModel>> setupCompany({
    required String companyName,
    required String ownerName,
    required String ownerUid,
    required String phone,
    required int teamSize,
  }) async {
    return performApiRequest<CompanyResponseModel>(
      _dio.post(
        ApiEndpoints.admin.company,
        data: {
          'companyName': companyName,
          'ownerName': ownerName,
          'ownerUid': ownerUid,
          'ownerPhone': phone,
          'teamSize': teamSize,
        },
      ),
          (json) => CompanyResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
