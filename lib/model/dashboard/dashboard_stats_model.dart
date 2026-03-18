class DashboardStatsModel {
  final int crewPresent;
  final int totalCrew;
  final int activeWorkers;
  final int tasksActive;
  final int completed;
  final int delayed;
  final int safetyScore;

  DashboardStatsModel({
    required this.crewPresent,
    required this.totalCrew,
    required this.activeWorkers,
    required this.tasksActive,
    required this.completed,
    required this.delayed,
    required this.safetyScore,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      crewPresent: json['crew_present'] ?? 0,
      totalCrew: json['total_crew'] ?? 0,
      activeWorkers: json['active_workers'] ?? 0,
      tasksActive: json['tasks_active'] ?? 0,
      completed: json['completed'] ?? 0,
      delayed: json['delayed'] ?? 0,
      safetyScore: json['safety_score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crew_present': crewPresent,
      'total_crew': totalCrew,
      'active_workers': activeWorkers,
      'tasks_active': tasksActive,
      'completed': completed,
      'delayed': delayed,
      'safety_score': safetyScore,
    };
  }

  // Factory for an empty/initial state
  factory DashboardStatsModel.empty() {
    return DashboardStatsModel(
      crewPresent: 0,
      totalCrew: 0,
      activeWorkers: 0,
      tasksActive: 0,
      completed: 0,
      delayed: 0,
      safetyScore: 0,
    );
  }
}
