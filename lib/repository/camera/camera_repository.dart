import '../../network/api_endpoints.dart';
import '../../network/api_providers.dart';
import '../../model/camera/camera_model.dart';
import 'dart:developer';

class CameraRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<CameraModel>> getCameras() async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoint.getCameras,
        requiresAuth: true,
      );

      if (response != null && response is List) {
        return response.map((json) => CameraModel.fromJson(json)).toList();
      }
    } catch (e) {
      log("Error fetching cameras: $e");
      rethrow;
    }
    return [];
  }
}
