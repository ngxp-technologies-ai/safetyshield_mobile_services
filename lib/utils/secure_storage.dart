import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  static const _accessTokenKey = "access_token";
  static const _refreshTokenKey = "refresh_token";
  static const _userRoleKey = "user_role";

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Store access token
  static Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
    log("Access token stored");
  }

  /// Store refresh token
  static Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
    log("Refresh token stored");
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Store user role
  static Future<void> storeUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  /// Check if logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout
  static Future<void> clearSession() async {
    await _storage.deleteAll();
    log("Secure storage cleared");
  }
}