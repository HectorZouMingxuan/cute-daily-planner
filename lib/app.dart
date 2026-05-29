import 'package:flutter/material.dart';

import 'screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/weekly_overview_screen.dart';
import 'theme/app_theme.dart';

class CuteCalendarApp extends StatelessWidget {
  const CuteCalendarApp({super.key});

  static const loginRoute = '/';
  static const calendarRoute = '/calendar';
  static const weeklyRoute = '/weekly';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cute Daily Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: loginRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case loginRoute:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );
          case calendarRoute:
            final username = settings.arguments as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => CalendarScreen(username: username),
            );
          case weeklyRoute:
            return MaterialPageRoute(
              builder: (_) => const WeeklyOverviewScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );
        }
      },
    );
  }
}
