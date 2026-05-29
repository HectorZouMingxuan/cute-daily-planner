import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/weekly_overview_screen.dart';
import 'theme/app_theme.dart';

class CuteCalendarApp extends ConsumerWidget {
  const CuteCalendarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Cute Daily Planner',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const AuthGate(),
      routes: {
        '/weekly': (_) => const WeeklyOverviewScreen(),
      },
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (_, next) {
      final user = next.asData?.value;
      if (user != null) {
        ref.read(themeModeProvider.notifier).applyPreference(
              user.darkModeEnabled,
            );
      }
    });

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      data: (user) {
        if (user == null) return const LoginScreen();
        return const CalendarScreen();
      },
      error: (_, _) => const LoginScreen(),
    );
  }
}
