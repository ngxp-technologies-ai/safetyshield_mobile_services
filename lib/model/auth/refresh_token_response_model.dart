class RefreshTokenResponseModel {
  final String accessToken;
  final String tokenType;

  const RefreshTokenResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json["access_token"] ?? "",
      tokenType: json["token_type"] ?? "",
    );
  }
}
