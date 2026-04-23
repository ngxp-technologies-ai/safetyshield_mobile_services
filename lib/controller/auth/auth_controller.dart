import 'package:flutter/material.dart';
import 'package:safety_management/model/auth/login_request_model.dart';
import 'package:safety_management/model/auth/login_response_model.dart';
import 'package:safety_management/model/auth/refresh_token_request_model.dart';
import 'package:safety_management/repository/auth/auth_repository.dart';
import 'package:safety_management/utils/notify_snackbar.dart';
import '../../utils/secure_storage.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;
  bool autoValidate = false;

  LoginResponseModel? session;

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  bool get isLoginButtonEnabled =>
      emailController.text.trim().isNotEmpty &&
      passwordController.text.isNotEmpty &&
      !isLoading;

  void onFieldsChanged() {
    notifyListeners();
  }

  Future<bool> login() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      autoValidate = true;
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final request = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final response = await _repo.login(request);

      session = response;

      await SecureStorage.storeAccessToken(response.accessToken);
      await SecureStorage.storeRefreshToken(response.refreshToken);
      await SecureStorage.storeUserRole(response.role);

      NotifySnackBar.show("Login successful", SnackBarType.success);
      return true;
    } catch (e) {
      NotifySnackBar.show(_readableErrorMessage(e), SnackBarType.fail);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> restoreSession() async {
    try {
      final accessToken = await SecureStorage.getAccessToken();
      final refreshToken = await SecureStorage.getRefreshToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        return true;
      }

      if (refreshToken != null && refreshToken.isNotEmpty) {
        return await refreshSession(showMessage: false);
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> refreshSession({bool showMessage = false}) async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await logout();
        return false;
      }

      final request = RefreshTokenRequestModel(refreshToken: refreshToken);

      final response = await _repo.refreshAccessToken(request);

      await SecureStorage.storeAccessToken(response.accessToken);

      if (showMessage) {
        NotifySnackBar.show("Session refreshed", SnackBarType.success);
      }

      return true;
    } catch (e) {
      await logout();

      if (showMessage) {
        NotifySnackBar.show(_readableErrorMessage(e), SnackBarType.fail);
      }

      return false;
    }
  }

  String _readableErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith("Exception: ")) {
      return message.replaceFirst("Exception: ", "");
    }

    return "Something went wrong. Please try again.";
  }

  Future<bool> checkSession() async {
    return await restoreSession();
  }

  Future<void> logout() async {
    await SecureStorage.clearSession();

    session = null;
    rememberMe = false;
    obscurePassword = true;
    autoValidate = false;
    isLoading = false;

    emailController.clear();
    passwordController.clear();

    NotifySnackBar.show("Logged out successfully", SnackBarType.success);

    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
