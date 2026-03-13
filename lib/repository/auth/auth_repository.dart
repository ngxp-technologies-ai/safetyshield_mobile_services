import 'package:dio/dio.dart';
import 'package:safety_management/model/auth/login_request_model.dart';
import 'package:safety_management/model/auth/login_response_model.dart';
import 'package:safety_management/model/auth/refresh_token_request_model.dart';
import 'package:safety_management/model/auth/refresh_token_response_model.dart';
import 'package:safety_management/network/api_endpoints.dart';
import '../../network/api_providers.dart';

class AuthRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoint.login,
        body: request.toJson(),
        requiresAuth: false,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is Map<String, dynamic>) {
        if (response["access_token"] != null) {
          return LoginResponseModel.fromJson(response);
        }

        if (response["detail"] != null) {
          throw Exception(response["detail"].toString());
        }
      }

      throw Exception("Something went wrong. Please try again.");
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final detail = data["detail"];
        if (detail != null && detail.toString().trim().isNotEmpty) {
          throw Exception(detail.toString());
        }
      }

      if (e.response?.statusCode == 401) {
        throw Exception("Invalid credentials");
      }

      throw Exception("Unable to login. Please try again.");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Unable to login. Please try again.");
    }
  }

  Future<RefreshTokenResponseModel> refreshAccessToken(
      RefreshTokenRequestModel request,
      ) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoint.refreshToken,
        body: request.toJson(),
        requiresAuth: false,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is Map<String, dynamic>) {
        if (response["access_token"] != null) {
          return RefreshTokenResponseModel.fromJson(response);
        }

        if (response["detail"] != null) {
          throw Exception(response["detail"].toString());
        }
      }

      throw Exception("Unable to refresh session.");
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final detail = data["detail"];
        if (detail != null && detail.toString().trim().isNotEmpty) {
          throw Exception(detail.toString());
        }
      }

      throw Exception("Session expired. Please login again.");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Session expired. Please login again.");
    }
  }
}