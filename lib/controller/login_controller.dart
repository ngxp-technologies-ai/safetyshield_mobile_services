import 'package:flutter/material.dart';
import 'package:safety_management/model/auth/login_request_model.dart';
import 'package:safety_management/model/auth/login_response_model.dart';
import 'package:safety_management/repository/auth/auth_repository.dart';
import 'package:safety_management/utils/notify_snackbar.dart';

import '../utils/secure_storage.dart';

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

      NotifySnackBar.show("Login successful", SnackBarType.Success);
      return true;
    } catch (e) {
      NotifySnackBar.show(_readableErrorMessage(e), SnackBarType.Fail);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
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
    final token = await SecureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await SecureStorage.clearSession();
    session = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}