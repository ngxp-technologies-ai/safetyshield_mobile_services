enum EquipmentStatus { active, idle, maintenance }

class EquipmentModel {
  final int id;
  final String name;
  final String equipmentCode;
  final String equipmentType;
  final EquipmentStatus status;
  final int siteId;
  final double utilization; // 0.0 to 1.0
  final String? operatorName;
  final double hoursToday;
  final int fuelLevel;
  final String? lastMovedAt;
  final String? zoneName;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.equipmentCode,
    required this.equipmentType,
    required this.status,
    required this.siteId,
    required this.utilization,
    this.operatorName,
    required this.hoursToday,
    required this.fuelLevel,
    this.lastMovedAt,
    this.zoneName,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] ?? '',
      equipmentCode: json['equipment_code'] ?? '',
      equipmentType: json['equipment_type'] ?? '',
      status: _parseStatus(json['status']),
      siteId: (json['site_id'] ?? 0 as num).toInt(),
      utilization: ((json['utilization_today'] ?? 0) as num).toDouble() / 100,
      operatorName: _parseOperator(json['operator']),
      hoursToday: ((json['hours_today'] ?? 0) as num).toDouble(),
      fuelLevel: ((json['fuel_level'] ?? 0) as num).toInt(),
      lastMovedAt: json['last_moved_at'],
      zoneName: json['current_zone'] != null ? json['current_zone']['name'] : null,
    );
  }

  static EquipmentStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return EquipmentStatus.active;
      case 'idle':
        return EquipmentStatus.idle;
      case 'maintenance':
        return EquipmentStatus.maintenance;
      default:
        return EquipmentStatus.idle;
    }
  }

  static String? _parseOperator(dynamic operator) {
    if (operator == null) return null;
    if (operator is String) return operator;
    if (operator is Map) return operator['full_name'] ?? operator['name'] ?? operator.toString();
    return operator.toString();
  }

  String get statusLabel {
    switch (status) {
      case EquipmentStatus.active:
        return 'Active';
      case EquipmentStatus.idle:
        return 'Idle';
      case EquipmentStatus.maintenance:
        return 'Maintenance';
    }
  }

  String get runtimeToday => '${hoursToday}h today';
  String get fuelDisplay => '$fuelLevel%';
}
