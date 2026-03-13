import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/view/dashboard_screen.dart';
import 'package:safety_management/view/welcome_screen.dart';

import '../controller/login_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final auth = context.read<AuthController>();

    final loggedIn = await auth.checkSession();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const DashboardScreen() : const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(child: Image.asset('assets/icons/sa_logo.png', height: 120)),
    );
  }
}
