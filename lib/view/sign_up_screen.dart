import 'package:flutter/material.dart';
import '../utils/app_size.dart';
import '../utils/screen_size.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              "assets/images/sign_up_curve_img.png",
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
              padding: EdgeInsets.only(top: ScreenSize.height * 0.25),
              child: Container(
                width: ScreenSize.width,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Title
                    const Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// Full Name
                    _inputField(
                      hint: "Full name",
                      icon: Icons.person_outline,
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Phone
                    _inputField(
                      hint: "Phone",
                      icon: Icons.phone_android_outlined,
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Email
                    _inputField(
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Password
                    _inputField(
                      hint: "Password",
                      icon: Icons.visibility_outlined,
                      isPassword: true,
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// Confirm Password
                    _inputField(
                      hint: "Confirm password",
                      icon: Icons.visibility_outlined,
                      isPassword: true,
                    ),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// Register Button
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
                        onPressed: () {},
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
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

                    /// Bottom Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
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
              onTap: ()  {
                print("BACK PRESSED");
                Navigator.pop(context);},
              child: Image.asset(
                'assets/icons/back_icon_blue.png',
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
    );
  }
}