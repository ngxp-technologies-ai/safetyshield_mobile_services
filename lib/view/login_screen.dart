import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/view/dashboard_screen.dart';
import 'package:safety_management/view/sign_up_screen.dart';
import '../utils/app_size.dart';
import '../utils/screen_size.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Background Image
          SizedBox(
            width: ScreenSize.width,
            child: Image.asset(
              "assets/images/login_curve_img.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Logo
          Positioned(
            top: ScreenSize.height * 0.06,
            right: ScreenSize.width * 0.05,
            child: Image.asset(
              "assets/icons/sa_logo_white_bg.png",
              height: ScreenSize.height * 0.05,
            ),
          ),

          /// Form Section
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.40),
              child: Container(
                width: ScreenSize.width,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      "Login",
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// Email
                    _inputField(hint: "Email", icon: Icons.email_outlined),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Password
                    _inputField(
                      hint: "Password",
                      icon: Icons.visibility_outlined,
                      isPassword: true,
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Remember + Forgot
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (v) {}),
                        Text("Remember Me",   style: AppStyles.poppins(
                          fontSize: AppSizes.fs12,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text("Forgot Password?",   style: AppStyles.poppins(
                            fontSize: AppSizes.fs12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400))
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Login Button
                    SizedBox(
                      width: ScreenSize.width,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F8FB5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DashboardScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: AppStyles.poppins(color: AppColors.white),
                        ),
                      ),
                    ),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// OR Divider
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("or"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// Social Icons
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

                    /// Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New here? ",  style: AppStyles.poppins(
                          fontSize: AppSizes.fs12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400)),
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

          /// Back Button
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
  }

  /// Reusable Input Field
  Widget _inputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    style: AppStyles.poppins(
    fontSize: AppSizes.fs12,
    color: AppColors.grey,
    fontWeight: FontWeight.w400),
    );
  }
}
