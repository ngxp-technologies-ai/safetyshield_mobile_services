class CameraModel {
  final int id;
  final String cameraId;
  final String name;
  final int siteId;
  final ZoneModel? zone;
  final String? locationDescription;
  final bool isActive;
  final int alertCount; // Added to match UI requirements

  CameraModel({
    required this.id,
    required this.cameraId,
    required this.name,
    required this.siteId,
    this.zone,
    this.locationDescription,
    required this.isActive,
    this.alertCount = 0,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'] ?? 0,
      cameraId: json['camera_id'] ?? '',
      name: json['name'] ?? '',
      siteId: json['site_id'] ?? 0,
      zone: json['zone'] != null ? ZoneModel.fromJson(json['zone']) : null,
      locationDescription: json['location_description'],
      isActive: json['is_active'] ?? false,
      alertCount: json['alert_count'] ?? 0, // Assuming API might provide this later
    );
  }
}

class ZoneModel {
  final int id;
  final String name;

  ZoneModel({
    required this.id,
    required this.name,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
