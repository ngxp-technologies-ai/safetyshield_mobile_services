class MyCrewResponseModel {
  final int total;
  final List<CrewWorkerModel> workers;

  const MyCrewResponseModel({required this.total, required this.workers});

  factory MyCrewResponseModel.fromJson(Map<String, dynamic> json) {
    return MyCrewResponseModel(
      total: json['total'] ?? 0,
      workers: (json['workers'] as List<dynamic>? ?? [])
          .map((e) => CrewWorkerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CrewWorkerModel {
  final String id;
  final String fullName;
  final String? employeeId;
  final String? designation;
  final String? department;
  final String status;
  final bool isCertified;
  final String? currentTask;
  final String? ppeCompliance;
  final String? fatigueLevel;
  final List<String> recentAlerts;

  const CrewWorkerModel({
    required this.id,
    required this.fullName,
    required this.employeeId,
    required this.designation,
    required this.department,
    required this.status,
    required this.isCertified,
    required this.currentTask,
    required this.ppeCompliance,
    required this.fatigueLevel,
    required this.recentAlerts,
  });

  factory CrewWorkerModel.fromJson(Map<String, dynamic> json) {
    return CrewWorkerModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      employeeId: json['employee_id'],
      designation: json['designation'],
      department: json['department'],
      status: json['status'] ?? '',
      isCertified: json['is_certified'] ?? false,
      currentTask: json['current_task'],
      ppeCompliance: json['ppe_compliance'],
      fatigueLevel: json['fatigue_level'],
      recentAlerts: (json['recent_alerts'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
