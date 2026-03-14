import 'package:dio/dio.dart';
import 'package:safety_management/model/crew/my_crew_response_model.dart';
import 'package:safety_management/network/api_endpoints.dart';
import 'package:safety_management/network/api_providers.dart';

class MyCrewRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<MyCrewResponseModel> getMyCrew({String? search}) async {
    try {
      String endpoint = ApiEndpoint.getMyCrew;

      if (search != null && search.trim().isNotEmpty) {
        endpoint =
            '$endpoint?search=${Uri.encodeQueryComponent(search.trim())}';
      }

      final response = await _apiProvider.get(endpoint, requiresAuth: true);

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is Map<String, dynamic>) {
        if (response['workers'] != null) {
          return MyCrewResponseModel.fromJson(response);
        }

        if (response['detail'] != null) {
          throw Exception(response['detail'].toString());
        }
      }

      throw Exception("Unable to fetch crew list");
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final detail = data['detail'];
        if (detail != null && detail.toString().trim().isNotEmpty) {
          throw Exception(detail.toString());
        }
      }

      throw Exception("Unable to fetch crew list");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to fetch crew list");
    }
  }
}
