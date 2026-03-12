import 'package:flutter/material.dart';
import '../pages/splash/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/tests/tests_list_page.dart';
import '../pages/tests/test_question_page.dart';
import '../pages/tests/result_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/settings/settings_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashPage(),
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomePage(),
    '/tests': (context) => const TestsListPage(),
    '/question': (context) => const TestQuestionPage(),
    '/result': (context) => const ResultPage(),
    '/profile': (context) => const ProfilePage(),
    '/settings': (context) => const SettingsPage(),
  };
}