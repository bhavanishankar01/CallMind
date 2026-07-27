import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/main_navigation_screen.dart';
import '../../features/reminders/create_reminder_screen.dart';
import '../../features/reminders/reminder_detail_screen.dart';
import '../../features/settings/settings_screen.dart';

final routerKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: routerKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/create-reminder',
      builder: (context, state) => const CreateReminderScreen(),
    ),
    GoRoute(
      path: '/reminder-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ReminderDetailScreen(reminderId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
