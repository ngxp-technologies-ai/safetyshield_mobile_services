import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/utils/notify_snackbar.dart';
import 'package:safety_management/view/splash_screen.dart';
import 'controller/auth/auth_controller.dart';
import 'controller/crew/my_crew_controller.dart';
import 'controller/alert/alert_stats_controller.dart';
import 'controller/alert/alert_controller.dart';
import 'controller/equipment/equipment_controller.dart';
import 'controller/zone/zone_controller.dart';
import 'controller/dashboard/dashboard_controller.dart';
import 'controller/task/task_controller.dart';
import 'controller/camera/camera_controller.dart';
import 'package:fvp/fvp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerWith();
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
        ChangeNotifierProvider(create: (_) => ZoneController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => CameraController()),

      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        scaffoldMessengerKey: NotifySnackBar.scaffoldMessengerKey,

        home: const SplashScreen(),
      ),
    );
  }
}
