import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/utils/validators.dart';
import 'package:safety_management/view/dashboard_screen.dart';
import 'package:safety_management/view/sign_up_screen.dart';
import '../controller/login_controller.dart';
import '../utils/app_size.dart';
import '../utils/screen_size.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SizedBox(
                width: ScreenSize.width,
                child: Image.asset(
                  "assets/images/login_curve_img.png",
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: ScreenSize.height * 0.06,
                right: ScreenSize.width * 0.05,
                child: Image.asset(
                  "assets/icons/sa_logo_white_bg.png",
                  height: ScreenSize.height * 0.05,
                ),
              ),

              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenSize.height * 0.40),
                  child: Container(
                    width: ScreenSize.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPadding,
                    ),
                    child: Form(
                      key: authController.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs26,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),

                          SizedBox(height: AppSizes.spaceMedium),

                          _inputField(
                            controller: authController.emailController,
                            hint: "Email",
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                            autoValidate: authController.autoValidate,
                            onChanged: (_) => authController.onFieldsChanged(),
                          ),

                          SizedBox(height: AppSizes.spaceSmall),

                          _inputField(
                            controller: authController.passwordController,
                            hint: "Password",
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: authController.obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            isPassword: authController.obscurePassword,
                            onSuffixTap: authController.togglePasswordVisibility,
                            validator: Validators.validatePassword,
                            autoValidate: authController.autoValidate,
                            onChanged: (_) => authController.onFieldsChanged(),
                          ),

                          SizedBox(height: AppSizes.spaceSmall),

                          Row(
                            children: [
                              Checkbox(
                                value: authController.rememberMe,
                                onChanged: authController.toggleRememberMe,
                              ),
                              Text(
                                "Remember Me",
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs12,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: AppStyles.poppins(
                                    fontSize: AppSizes.fs12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.spaceSmall),

                          SizedBox(
                            width: ScreenSize.width,
                            height: AppSizes.buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F8FB5),
                                disabledBackgroundColor:
                                const Color(0xFF1F8FB5).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: authController.isLoginButtonEnabled
                                  ? () async {
                                final success =
                                await authController.login();

                                if (success && context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const DashboardScreen(),
                                    ),
                                  );
                                }
                              }
                                  : null,
                              child: authController.isLoading
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                "Login",
                                style: AppStyles.poppins(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: AppSizes.spaceMedium),

                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("or"),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),

                          SizedBox(height: AppSizes.spaceMedium),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/google_icon.png",
                                height: AppSizes.socialIcon,
                              ),
                              SizedBox(width: ScreenSize.width * 0.06),
                              Image.asset(
                                "assets/icons/fb_icon.png",
                                height: AppSizes.socialIcon,
                              ),
                              SizedBox(width: ScreenSize.width * 0.06),
                              Image.asset(
                                "assets/icons/apple_icon.png",
                                height: AppSizes.socialIcon,
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.spaceMedium),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New here? ",
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs12,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create an Account",
                                  style: AppStyles.poppins(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.spaceLarge),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: ScreenSize.height * 0.06,
                left: ScreenSize.width * 0.05,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/icons/back_icon_black.png',
                    width: ScreenSize.width * 0.10,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool isPassword = false,
    bool autoValidate = false,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.poppins(
          fontSize: AppSizes.fs12,
          color: AppColors.grey,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: Icon(prefixIcon, color: AppColors.grey),
        suffixIcon: suffixIcon != null
            ? IconButton(
          onPressed: onSuffixTap,
          icon: Icon(suffixIcon, color: AppColors.grey),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorMaxLines: 2,
      ),
      style: AppStyles.poppins(
        fontSize: AppSizes.fs12,
        color: AppColors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}