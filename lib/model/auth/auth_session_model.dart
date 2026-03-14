class AuthSessionModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String fullName;

  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.fullName,
  });
}
