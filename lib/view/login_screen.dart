import 'package:flutter/material.dart';
import 'package:safety_management/view/sign_up_screen.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Background Image
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/login_curve_img.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/icons/back_icon_black.png',
                width: 40,
                height: 40,
              ),
            ),
          ),

          /// Logo
          Positioned(
            top: 50,
            right: 20,
            child: Image.asset(
              "assets/images/sa_logo_white_bg.png",
              height: 40,
            ),
          ),

          /// Form Section
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 360),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Email Field
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        suffixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        suffixIcon: const Icon(Icons.visibility_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Remember + Forgot
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (v) {}),
                        const Text("Remember Me"),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F8FB5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DashboardScreen()),
                        );},
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

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

                    const SizedBox(height: 20),

                    /// Social Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/google_icon.png", height: 32),
                        const SizedBox(width: 25),
                        Image.asset("assets/icons/fb_icon.png", height: 32),
                        const SizedBox(width: 25),
                        Image.asset("assets/icons/apple_icon.png", height: 32),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New here? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignUpScreen()),
                            );
                          },
                          child: const Text(
                            "Create an Account",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
