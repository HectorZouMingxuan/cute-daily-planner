import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/theme_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/weekly_overview_screen.dart';
import 'theme/app_theme.dart';

class CuteCalendarApp extends ConsumerWidget {
  const CuteCalendarApp({super.key});

  static const loginRoute = '/';
  static const calendarRoute = '/calendar';
  static const weeklyRoute = '/weekly';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Cute Daily Planner',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
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
