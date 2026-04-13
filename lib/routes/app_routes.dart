import 'package:flutter/material.dart';
import '../pages/splash/splash_page.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart' as home;
import '../pages/tests/tests_list_page.dart';
import '../pages/lessons/lesson_detail_page.dart' as lesson_detail;
import '../pages/tests/test_question_page.dart';
import '../pages/tests/test_result_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/settings/settings_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashPage(),
    '/onboarding': (context) => const OnboardingPage(),
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const home.HomePage(),
    '/tests': (context) => const TestsListPage(),
    '/lessons': (context) => const lesson_detail.LessonListPage(),
    '/lesson_detail': (context) => const lesson_detail.LessonDetailPage(),
    '/question': (context) => const TestQuestionPage(),
    '/result': (context) => const ResultPage(),
    '/profile': (context) => const ProfilePage(),
    '/settings': (context) => SettingsPage(onThemeChanged: (isDark) {}),
  };
}
