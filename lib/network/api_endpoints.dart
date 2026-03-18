class ApiEndpoint {
  static const String baseUrl = "https://safetyapi.prod-app.in";

  static const String refreshToken = "/api/auth/refresh";
  static const String login = "/api/auth/login";

  static const String getMyCrew = "/api/supervisor/my-crew";
  static const String dashboardStats = "/api/supervisor/dashboard/stats";
  static const String alertStats = "/api/alerts/stats";
  static const String activeAlerts = "/api/alerts/active";
  static const String acknowledgedAlerts = "/api/alerts/acknowledged";
  static String acknowledgeAlert(int id) => "/api/alerts/$id/acknowledge";

  static const String getZones = "/api/zones/";
  static const String getEquipment = "/api/equipment/";
  static const String tasks = "/api/admin/tasks/";
}
