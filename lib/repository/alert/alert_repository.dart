import 'package:dio/dio.dart';
import 'package:safety_management/model/alert/alert_model.dart';
import 'package:safety_management/model/alert/alert_stats_model.dart';
import 'package:safety_management/network/api_endpoints.dart';
import 'package:safety_management/network/api_providers.dart';

class AlertRepository {
  final ApiProvider _apiProvider = ApiProvider();
//get alert stats count of active and acknowledged alerts
  Future<AlertStatsModel> getAlertStats() async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoint.alertStats,
        requiresAuth: true,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is Map<String, dynamic>) {
        return AlertStatsModel.fromJson(response);
      }

      throw Exception("Unable to fetch alert stats");
    } on DioException catch (e) {
      _handleDioError(e, "Unable to fetch alert stats");
      rethrow; // Should not reach here
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to fetch alert stats");
    }
  }
//get list of active alerts and acknowledged alerts with pagination
  Future<List<AlertModel>> getActiveAlerts({
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final response = await _apiProvider.get(
        "${ApiEndpoint.activeAlerts}?skip=$skip&limit=$limit",
        requiresAuth: true,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is List) {
        return response
            .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("Unable to fetch active alerts");
    } on DioException catch (e) {
      _handleDioError(e, "Unable to fetch active alerts");
      rethrow; // Should not reach here
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to fetch active alerts");
    }
  }
//get list of acknowledged alerts with pagination
  Future<List<AlertModel>> getAcknowledgedAlerts({
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final response = await _apiProvider.get(
        "${ApiEndpoint.acknowledgedAlerts}?skip=$skip&limit=$limit",
        requiresAuth: true,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is List) {
        return response
            .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("Unable to fetch acknowledged alerts");
    } on DioException catch (e) {
      _handleDioError(e, "Unable to fetch acknowledged alerts");
      rethrow; // Should not reach here
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to fetch acknowledged alerts");
    }
  }

//acknowledge an alert by id

  Future<void> acknowledgeAlert(int id) async {
    try {
      await _apiProvider.post(
        ApiEndpoint.acknowledgeAlert(id),
        body: {},
        requiresAuth: true,
      );
    } on DioException catch (e) {
      _handleDioError(e, "Unable to acknowledge alert");
      rethrow;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to acknowledge alert");
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
