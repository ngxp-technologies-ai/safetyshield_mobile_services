import 'dart:developer';
import 'package:safety_management/network/api_endpoints.dart';
import 'package:safety_management/network/api_providers.dart';
import '../../model/zone/zone_model.dart';

class ZoneRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<ZoneModel>> getZones() async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoint.getZones,
        requiresAuth: true,
      );

      if (response != null && response is List) {
        return response.map((json) => ZoneModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      log("Error fetching zones: $e");
      rethrow;
    }
  }
}
