import 'package:flutter/material.dart';
import 'package:safety_management/view/sign_up_screen.dart';
import '../utils/app_size.dart';
import '../utils/screen_size.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Top Curve Image
          SizedBox(
            width: ScreenSize.width,
            child: Image.asset(
              'assets/images/welcome_curve_img.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Page Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ScreenSize.height * 0.25),

              /// Logo
              Container(
                height: AppSizes.logoSize,
                width: AppSizes.logoSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenSize.width * 0.03),
                  child: Image.asset("assets/images/sa_logo.png"),
                ),
              ),

              SizedBox(height: AppSizes.spaceSmall),

              /// Welcome Text
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: ScreenSize.height * 0.008),

              const Text(
                "Please login to continue",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: AppSizes.spaceMedium),

              /// Login Button
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding),
                child: SizedBox(
                  width: ScreenSize.width,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F8FB5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.spaceSmall),

              /// Sign Up Button
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding),
                child: SizedBox(
                  width: ScreenSize.width,
                  height: AppSizes.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.spaceLarge),

              /// OR Divider
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width * 0.10),
                child: const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
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
            ],
          ),
        ],
      ),
    );
  }
}