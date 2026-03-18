class ZoneModel {
  final int id;
  final String name;
  final int siteId;
  final String siteName;
  final String? cameraId;
  final List<String> ppeRequired;
  final String zoneType;
  final String hazardLevel;
  final int workerCapacity;
  final int currentWorkers;
  final bool geofenced;
  final bool isActive;
  final DateTime createdAt;

  // Additional fields for UI based on mockup (might need mocking if not in API)
  final List<String> restrictedActivities;
  final List<String> permits;
  final List<String> risks;

  ZoneModel({
    required this.id,
    required this.name,
    required this.siteId,
    required this.siteName,
    this.cameraId,
    required this.ppeRequired,
    required this.zoneType,
    required this.hazardLevel,
    required this.workerCapacity,
    required this.currentWorkers,
    required this.geofenced,
    required this.isActive,
    required this.createdAt,
    this.restrictedActivities = const [],
    this.permits = const [],
    this.risks = const [],
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'],
      name: json['name'] ?? '',
      siteId: json['site_id'],
      siteName: json['site_name'] ?? '',
      cameraId: json['camera_id'],
      ppeRequired: List<String>.from(json['ppe_required'] ?? []),
      zoneType: json['zone_type'] ?? '',
      hazardLevel: json['hazard_level'] ?? '',
      workerCapacity: json['worker_capacity'] ?? 0,
      currentWorkers: json['current_workers'] ?? 0,
      geofenced: json['geofenced'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      // Mocking these for now as they aren't in the provided JSON snippet but are in Figma
      restrictedActivities: json['restricted_activities'] != null 
          ? List<String>.from(json['restricted_activities'])
          : ["No heavy vehicle operation without spotter"],
      permits: json['permits'] != null 
          ? List<String>.from(json['permits'])
          : ["Excavation permit required for depth > 1.5m"],
      risks: json['risks'] != null 
          ? List<String>.from(json['risks'])
          : ["Cave-in risk", "Water accumulation"],
    );
  }
}
