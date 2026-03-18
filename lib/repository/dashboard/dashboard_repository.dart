import 'package:dio/dio.dart';
import 'package:safety_management/model/dashboard/dashboard_stats_model.dart';
import 'package:safety_management/network/api_endpoints.dart';
import 'package:safety_management/network/api_providers.dart';

class DashboardRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoint.dashboardStats,
        requiresAuth: true,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is Map<String, dynamic>) {
        return DashboardStatsModel.fromJson(response);
      }

      throw Exception("Unable to fetch dashboard stats");
    } on DioException catch (e) {
      _handleDioError(e, "Unable to fetch dashboard stats");
      rethrow; 
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to fetch dashboard stats");
    }
  }

  void _handleDioError(DioException e, String defaultMessage) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        throw Exception(detail.toString());
      }
    }

    throw Exception(defaultMessage);
  }
}
