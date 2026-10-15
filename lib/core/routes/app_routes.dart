import 'package:flutter/material.dart';
import '../../screens/splash_screen.dart';
import '../../screens/pet_profile_screen.dart';
// import '../../screens/dashboard_screen.dart';
// import '../../screens/activity_log_screen.dart';
// import '../../screens/notification_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const petProfile = '/pet-profile';
  static const dashboard = '/dashboard';
  static const activity = '/activity';
  static const notifications = '/notifications';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        petProfile: (_) => const PetProfileScreen(),
        // dashboard: (_) => const DashboardScreen(),
        // activity: (_) => const ActivityLogScreen(),
        // notifications: (_) => const NotificationScreen(),
      };
}