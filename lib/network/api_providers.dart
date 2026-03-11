// import 'dart:developer';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:safety_management/network/api_endpoints.dart';
// import '../view/login_screen.dart';
//
// class ApiProvider {
//   static final ApiProvider _instance = ApiProvider._internal();
//   late Dio _dio;
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   // Token refresh lock to prevent concurrent refresh attempts
//   bool _isRefreshing = false;
//   Future<bool>? _refreshFuture;
//
//   // Guard to prevent multiple simultaneous logout redirects
//   bool _isLoggingOut = false;
//
//   // Key used to mark retried requests (to prevent infinite retry loops)
//   static const String _retryKey = 'x-retry-attempt';
//
//   ApiProvider._internal() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: ApiEndpoint.baseUrl,
//         connectTimeout: const Duration(seconds: 15),
//         receiveTimeout: const Duration(seconds: 15),
//         headers: {"Content-Type": "application/json"},
//       ),
//     );
//
//     // Only enable verbose logging in debug mode
//     if (kDebugMode) {
//       _dio.interceptors.add(
//         PrettyDioLogger(
//           request: true,
//           requestBody: true,
//           responseBody: true,
//           error: true,
//           logPrint: (object) => debugPrint(object.toString()),
//         ),
//       );
//     }
//
//     // Add token refresh interceptor
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onError: (error, handler) async {
//           if (error.response?.statusCode == 401) {
//             // Skip token refresh for auth & token endpoints
//             final requestPath = error.requestOptions.path;
//             if (requestPath.contains('/login') ||
//                 requestPath.contains('/create-admin-manager') ||
//                 requestPath.contains('/refresh-token')) {
//               log("401 on auth/token endpoint - skipping token refresh");
//               return handler.reject(error);
//             }
//
//             // Prevent infinite retry loops - if this is already a retried request, don't retry again
//             if (error.requestOptions.headers[_retryKey] == true) {
//               log("401 on retried request - not retrying again");
//               return handler.reject(error);
//             }
//
//             // If already logging out, don't attempt refresh
//             if (_isLoggingOut) {
//               log("Already logging out - skipping token refresh");
//               return handler.reject(error);
//             }
//
//             log("401 Unauthorized - Attempting token refresh");
//
//             // Use lock to prevent concurrent refresh attempts
//             bool refreshed;
//             if (_isRefreshing) {
//               log("Token refresh already in progress, waiting...");
//               refreshed = await (_refreshFuture ?? Future.value(false));
//             } else {
//               _isRefreshing = true;
//               _refreshFuture = _refreshAccessToken();
//               refreshed = await _refreshFuture!;
//               _isRefreshing = false;
//               _refreshFuture = null;
//             }
//
//             if (refreshed) {
//               log("Token refreshed successfully, retrying original request");
//
//               // Retry the original request with new token
//               final options = error.requestOptions;
//               final token = await SecureStorage.getAccessToken();
//
//               if (token != null && token.isNotEmpty) {
//                 options.headers['Authorization'] = 'Bearer $token';
//                 options.headers[_retryKey] = true; // Mark as retried to prevent loops
//
//                 try {
//                   final response = await _dio.fetch(options);
//                   log("Original request succeeded after token refresh");
//                   return handler.resolve(response);
//                 } catch (e) {
//                   log("Original request failed even after token refresh: $e");
//                   return handler.reject(error);
//                 }
//               } else {
//                 log("No valid token after refresh");
//                 return handler.reject(error);
//               }
//             } else {
//               log("Token refresh failed - redirecting to login");
//               return handler.reject(error);
//             }
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }
//
//   factory ApiProvider() => _instance;
//
//   Future<bool> isConnectedToInternet() async {
//     try {
//       final result = await InternetAddress.lookup('www.google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (e) {
//       NotifySnackBar.show(
//         "Please check your internet connection and try again.",
//       );
//       return false;
//     }
//   }
//
//   Future<Map<String, dynamic>> _getHeaders({bool requiresAuth = false}) async {
//     final Map<String, dynamic> headers = {};
//     if (requiresAuth) {
//       final token = await SecureStorage.getAccessToken();
//       headers['Authorization'] = 'Bearer $token';
//       if (kDebugMode) log("Using auth token: ${token?.substring(0, 20)}...");
//     }
//     return headers;
//   }
//
//   /// Refresh the access token using the refresh token
//   Future<bool> _refreshAccessToken() async {
//     try {
//       final refreshToken = await SecureStorage.getRefreshToken();
//
//       if (refreshToken == null || refreshToken.isEmpty) {
//         log("❌ No refresh token available");
//         await _handleTokenRefreshFailure();
//         return false;
//       }
//
//       if (kDebugMode) log("🔄 Attempting to refresh access token...");
//       if (kDebugMode) log("Refresh token: ${refreshToken.substring(0, 20)}...");
//
//       final response = await _dio.post(
//         ApiEndpoint.refreshToken,
//         data: {'refreshToken': refreshToken},
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//           validateStatus: (status) => true,
//         ),
//       );
//
//       log("Refresh token response status: ${response.statusCode}");
//
//       if (response.statusCode == 200 && response.data != null) {
//         final newAccessToken = response.data['accessToken'];
//         final newRefreshToken = response.data['refreshToken'];
//
//         if (newAccessToken != null) {
//           await SecureStorage.storeAccessToken(newAccessToken);
//           log("✅ New access token stored");
//
//           if (newRefreshToken != null) {
//             await SecureStorage.storeRefreshToken(newRefreshToken);
//             log("✅ New refresh token stored");
//           }
//
//           log("✅ Access token refreshed successfully");
//           return true;
//         } else {
//           log("❌ No access token in refresh response");
//         }
//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         // Refresh token is genuinely expired/invalid - must logout
//         log("❌ Refresh token expired (status: ${response.statusCode})");
//         await _handleTokenRefreshFailure();
//         return false;
//       } else {
//         // Server error (500, 503, etc.) - don't clear tokens, just fail gracefully
//         log("❌ Token refresh server error. Status: ${response.statusCode}");
//         log("Response data: ${response.data}");
//         log("Not clearing tokens - server may be temporarily unavailable");
//         return false;
//       }
//
//       // No access token in 200 response (unexpected) - don't force logout
//       log("❌ Unexpected refresh response format - not clearing tokens");
//       return false;
//     } catch (e, stacktrace) {
//       // Network error (timeout, no internet, DNS failure) - don't clear tokens!
//       log('❌ Token refresh network error: $e');
//       log('Stacktrace: $stacktrace');
//       log('Not clearing tokens - network may be temporarily unavailable');
//       return false;
//     }
//   }
//
//   /// Handle token refresh failure by clearing tokens and redirecting to login.
//   /// Only called when the refresh token is genuinely expired (401/403 from
//   /// refresh endpoint), NOT on network errors or server errors.
//   Future<void> _handleTokenRefreshFailure() async {
//     // Guard: prevent multiple simultaneous logout redirects
//     if (_isLoggingOut) {
//       log("Already handling logout - skipping duplicate call");
//       return;
//     }
//     _isLoggingOut = true;
//
//     log("Token refresh failed. Clearing all tokens and redirecting to login.");
//
//     // Clear all stored tokens
//     await SecureStorage.deleteAllTokens();
//
//     // Reset all controller data to prevent stale data on re-login
//     final ctx = navigatorKey.currentState?.context;
//     if (ctx != null) {
//       try {
//         Provider.of<HomeScreenController>(ctx, listen: false).resetData();
//         Provider.of<BranchController>(ctx, listen: false).resetData();
//         Provider.of<ItemsController>(ctx, listen: false).resetData();
//         Provider.of<CompanySettingsController>(ctx, listen: false).resetData();
//       } catch (_) {}
//     }
//
//     // Show session expired message
//     NotifySnackBar.show(
//       "Session expired. Please login again.",
//       SnackBarType.Fail,
//     );
//
//     // Navigate to login screen using navigatorKey
//     if (navigatorKey.currentState != null) {
//       navigatorKey.currentState!.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//             (route) => false,
//       );
//     }
//
//     // Reset the flag after a short delay so future genuine logouts still work
//     Future.delayed(const Duration(seconds: 3), () {
//       _isLoggingOut = false;
//     });
//   }
//
//   /// Perform a PUT request
//   Future<dynamic> put(
//       String apiEndpoint, {
//         required dynamic body,
//         bool requiresAuth = false,
//       }) async {
//     if (!await isConnectedToInternet()) {
//       log("No internet connection");
//       return null;
//     }
//
//     try {
//       final response = await _dio.put(
//         apiEndpoint,
//         data: body,
//         options: Options(
//           headers: await _getHeaders(requiresAuth: requiresAuth),
//         ),
//       );
//
//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 204) {
//         return response.data ?? {}; // Return empty object for 204 responses
//       } else if (response.statusCode == 400) {
//         log("400 Response: ${response.data}");
//         return response.data;
//       } else {
//         log(
//           "PUT failed. Status: ${response.statusCode}, Data: ${response.data}",
//         );
//       }
//     } on DioException catch (e) {
//       // Handle 401 errors - they should be caught by interceptor
//       if (e.response?.statusCode == 401) {
//         log('401 error caught in PUT - should have been handled by interceptor');
//         throw e;
//       }
//       // Rethrow client errors (4xx) so callers can extract the error message
//       if (e.response != null && e.response!.statusCode != null &&
//           e.response!.statusCode! >= 400 && e.response!.statusCode! < 500) {
//         log('PUT client error ${e.response!.statusCode}: ${e.response!.data}');
//         rethrow;
//       }
//       log('PUT request failed: $e');
//       log('Stacktrace: ${e.stackTrace}');
//     } catch (e, stacktrace) {
//       log('PUT request failed: $e');
//       log('Stacktrace: $stacktrace');
//     }
//
//     return null;
//   }
//
//   /// Perform a GET request
//   Future<dynamic> get(
//       String apiEndpoint, {
//         bool requiresAuth = false,
//         Duration? receiveTimeout,
//       }) async {
//     if (!await isConnectedToInternet()) {
//       log("No internet connection");
//       return null;
//     }
//
//     try {
//       final response = await _dio.get(
//         apiEndpoint,
//         options: Options(
//           headers: await _getHeaders(requiresAuth: requiresAuth),
//           receiveTimeout: receiveTimeout,
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         return response.data;
//       } else if (response.statusCode == 400) {
//         log("400 Response: ${response.data}");
//         return response.data;
//       } else {
//         log(
//           "GET failed. Status: ${response.statusCode}, Data: ${response.data}",
//         );
//       }
//     } on DioException catch (e) {
//       // Handle 401 errors - they should be caught by interceptor
//       if (e.response?.statusCode == 401) {
//         log('401 error caught in GET - should have been handled by interceptor');
//         throw e;
//       }
//       log('GET request failed: $e');
//       log('Stacktrace: ${e.stackTrace}');
//     } catch (e, stacktrace) {
//       log('GET request failed: $e');
//       log('Stacktrace: $stacktrace');
//     }
//
//     return null;
//   }
//
//   /// Perform a POST request
//   Future<dynamic> post(
//       String apiEndpoint, {
//         required dynamic body,
//         bool requiresAuth = false,
//         Duration? sendTimeout,
//         Duration? receiveTimeout,
//       }) async {
//     if (!await isConnectedToInternet()) {
//       log("No internet connection");
//       return null;
//     }
//
//     try {
//       final response = await _dio.post(
//         apiEndpoint,
//         data: body,
//         options: Options(
//           headers: await _getHeaders(requiresAuth: requiresAuth),
//           sendTimeout: sendTimeout,
//           receiveTimeout: receiveTimeout,
//         ),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response.data;
//       } else if (response.statusCode == 400) {
//         log("400 Response: ${response.data}");
//         return response.data;
//       } else {
//         log(
//           "POST failed. Status: ${response.statusCode}, Data: ${response.data}",
//         );
//       }
//     } on DioException catch (e) {
//       // Handle 401 errors - they should be caught by interceptor
//       if (e.response?.statusCode == 401) {
//         log('401 error caught in POST - should have been handled by interceptor');
//         throw e;
//       }
//       // Return 400/409 response data so callers can extract error messages
//       if (e.response != null && e.response!.statusCode != null &&
//           e.response!.statusCode! >= 400 && e.response!.statusCode! < 500 &&
//           e.response!.data != null) {
//         log('${e.response!.statusCode} Response from DioException: ${e.response!.data}');
//         return e.response!.data;
//       }
//       log('POST request failed: $e');
//       log('Stacktrace: ${e.stackTrace}');
//     } catch (e, stacktrace) {
//       log('POST request failed: $e');
//       log('Stacktrace: $stacktrace');
//     }
//
//     return null;
//   }
//
//   /// Perform a POST request with FormData (multipart)
//   Future<dynamic> postFormData(
//       String apiEndpoint, {
//         required FormData formData,
//         bool requiresAuth = false,
//         void Function(int, int)? onSendProgress,
//         void Function(int, int)? onReceiveProgress,
//         Duration? sendTimeout,
//         Duration? receiveTimeout,
//       }) async {
//     if (!await isConnectedToInternet()) {
//       log("No internet connection");
//       return null;
//     }
//
//     try {
//       final headers = await _getHeaders(requiresAuth: requiresAuth);
//       headers['Content-Type'] = 'multipart/form-data';
//
//       final response = await _dio.post(
//         apiEndpoint,
//         data: formData,
//         options: Options(
//           headers: headers,
//           validateStatus: (status) => true,
//           sendTimeout: sendTimeout,
//           receiveTimeout: receiveTimeout,
//         ),
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response.data;
//       } else {
//         log(
//           "POST FormData failed. Status: ${response.statusCode}, Data: ${response.data}",
//         );
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//         );
//       }
//     } catch (e, stacktrace) {
//       if (e is DioException) rethrow;
//       log('POST FormData request failed: $e');
//       log('Stacktrace: $stacktrace');
//     }
//
//     return null;
//   }
//
//   /// Perform a PUT request with FormData (multipart)
//   Future<dynamic> putFormData(
//       String apiEndpoint, {
//         required FormData formData,
//         bool requiresAuth = false,
//       }) async {
//     if (!await isConnectedToInternet()) {
//       log("No internet connection");
//       return null;
//     }
//
//     try {
//       final headers = await _getHeaders(requiresAuth: requiresAuth);
//       headers['Content-Type'] = 'multipart/form-data';
//
//       final response = await _dio.put(
//         apiEndpoint,
//         data: formData,
//         options: Options(headers: headers, validateStatus: (status) => true),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
//         return response.data ?? {};
//       } else if (response.statusCode != null &&
//           response.statusCode! >= 400 && response.statusCode! < 500) {
//         log("${response.statusCode} Response: ${response.data}");
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//         );
//       } else {
//         log(
//           "PUT FormData failed. Status: ${response.statusCode}, Data: ${response.data}",
//         );
//       }
//     } catch (e, stacktrace) {
//       if (e is DioException) rethrow;
//       log('PUT FormData request failed: $e');
//       log('Stacktrace: $stacktrace');
//     }
//
//     return null;
//   }
//
//   /// Perform a DELETE request
//   Future<dynamic> delete(
//       String apiEndpoint, {
//         bool requiresAuth = false,
//       }) async {
//     if (!await isConnectedToInternet()) {
//       log("No internet connection");
//       return null;
//     }
//
//     try {
//       final response = await _dio.delete(
//         apiEndpoint,
//         options: Options(
//           headers: await _getHeaders(requiresAuth: requiresAuth),
//         ),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         return response.data;
//       } else if (response.statusCode == 400) {
//         log("400 Response: ${response.data}");
//         return response.data;
//       } else {
//         log(
//           "DELETE failed. Status: ${response.statusCode}, Data: ${response.data}",
//         );
//       }
//     } on DioException catch (e) {
//       // Handle 401 errors - they should be caught by interceptor
//       if (e.response?.statusCode == 401) {
//         log('401 error caught in DELETE - should have been handled by interceptor');
//         throw e;
//       }
//       // Return 400/409 response data so callers can extract error messages
//       if (e.response != null && e.response!.statusCode != null &&
//           e.response!.statusCode! >= 400 && e.response!.statusCode! < 500 &&
//           e.response!.data != null) {
//         log('${e.response!.statusCode} Response from DioException: ${e.response!.data}');
//         return e.response!.data;
//       }
//       log('DELETE request failed: $e');
//       log('Stacktrace: ${e.stackTrace}');
//     } catch (e, stacktrace) {
//       log('DELETE request failed: $e');
//       log('Stacktrace: $stacktrace');
//     }
//
//     return null;
//   }
// }