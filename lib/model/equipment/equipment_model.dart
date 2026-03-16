enum EquipmentStatus { active, idle, maintenance }

class EquipmentModel {
  final String id;
  final String name;
  final String location;
  final EquipmentStatus status;
  final double utilization; // 0.0 to 1.0
  final String? operatorName;
  final String? runtimeToday;
  final int alertCount;
  final String? alertMessage;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.utilization,
    this.operatorName,
    this.runtimeToday,
    this.alertCount = 0,
    this.alertMessage,
  });

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
}
