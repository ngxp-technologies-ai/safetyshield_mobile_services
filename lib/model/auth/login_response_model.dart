class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String role;
  final String fullName;
  final List<UserSite> sites;
  final List<UserZone> zones;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.role,
    required this.fullName,
    required this.sites,
    required this.zones,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json["access_token"] ?? "",
      refreshToken: json["refresh_token"] ?? "",
      tokenType: json["token_type"] ?? "",
      role: json["role"] ?? "",
      fullName: json["full_name"] ?? "",
      sites: (json["sites"] as List<dynamic>? ?? [])
          .map((e) => UserSite.fromJson(e as Map<String, dynamic>))
          .toList(),
      zones: (json["zones"] as List<dynamic>? ?? [])
          .map((e) => UserZone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UserSite {
  final int id;
  final String name;

  const UserSite({required this.id, required this.name});

  factory UserSite.fromJson(Map<String, dynamic> json) {
    return UserSite(id: json["id"] ?? 0, name: json["name"] ?? "");
  }
}

class UserZone {
  final int id;
  final String name;

  const UserZone({required this.id, required this.name});

  factory UserZone.fromJson(Map<String, dynamic> json) {
    return UserZone(id: json["id"] ?? 0, name: json["name"] ?? "");
  }
}
