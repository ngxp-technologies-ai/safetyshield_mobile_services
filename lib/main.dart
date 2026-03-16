import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/utils/notify_snackbar.dart';
import 'package:safety_management/view/splash_screen.dart';
import 'controller/auth/auth_controller.dart';
import 'controller/crew/my_crew_controller.dart';
import 'controller/alert/alert_stats_controller.dart';
import 'controller/alert/alert_controller.dart';
import 'controller/equipment/equipment_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => MyCrewController()),
        ChangeNotifierProvider(create: (_) => AlertStatsController()),
        ChangeNotifierProvider(create: (_) => AlertController()),
        ChangeNotifierProvider(create: (_) => EquipmentController()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        scaffoldMessengerKey: NotifySnackBar.scaffoldMessengerKey,

        home: const SplashScreen(),
      ),
    );
  }
}
