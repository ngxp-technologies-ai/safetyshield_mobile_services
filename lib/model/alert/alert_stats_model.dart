class AlertStatsModel {
  final int activeAlerts;
  final int criticalCount;
  final int acknowledgedToday;

  const AlertStatsModel({
    required this.activeAlerts,
    required this.criticalCount,
    required this.acknowledgedToday,
  });

  factory AlertStatsModel.fromJson(Map<String, dynamic> json) {
    return AlertStatsModel(
      activeAlerts: json['active_alerts'] ?? 0,
      criticalCount: json['critical_count'] ?? 0,
      acknowledgedToday: json['acknowledged_today'] ?? 0,
    );
  }

  factory AlertStatsModel.empty() {
    return const AlertStatsModel(
      activeAlerts: 0,
      criticalCount: 0,
      acknowledgedToday: 0,
    );
  }
}
