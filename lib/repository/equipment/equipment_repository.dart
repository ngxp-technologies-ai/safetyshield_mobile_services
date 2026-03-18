import 'dart:developer';
import 'package:safety_management/network/api_endpoints.dart';
import 'package:safety_management/network/api_providers.dart';
import '../../model/equipment/equipment_model.dart';

class EquipmentRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<EquipmentModel>> getEquipment({int? zoneId}) async {
    try {
      String endpoint = '${ApiEndpoint.getEquipment}?skip=0&limit=50';
      if (zoneId != null) {
        endpoint = '${ApiEndpoint.getEquipment}?zone_id=$zoneId&skip=0&limit=50';
      }

      log("Fetching equipment from: $endpoint");

      final response = await _apiProvider.get(
        endpoint,
        requiresAuth: true,
      );

      log("Equipment API response type: ${response.runtimeType}");

      if (response != null && response is List) {
        return response.map((json) => EquipmentModel.fromJson(json as Map<String, dynamic>)).toList();
      }

      // If response is a Map (paginated), try extracting the items
      if (response != null && response is Map) {
        final items = response['items'] ?? response['data'] ?? response['results'];
        if (items != null && items is List) {
          return items.map((json) => EquipmentModel.fromJson(json as Map<String, dynamic>)).toList();
        }
      }

      log("Equipment API returned unexpected format: $response");
      return [];
    } catch (e, stackTrace) {
      log("Error fetching equipment: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
