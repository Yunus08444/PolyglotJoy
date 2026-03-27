import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  User? _user;
  String? _error;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;
  String? get error => _error;

  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    final userJson = await _authService.getCurrentUser();
    if (userJson != null) {
      _user = User.fromJson(userJson);
      _isAuthenticated = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Начинаю логин с: $email');
      await _authService.login(email, password);
      print('JWT токен получен');

      final profile = await _authService.getCurrentUser();
      if (profile != null) {
        print('Профиль получен: $profile');
        _user = User.fromJson(profile);
        _isAuthenticated = true;
      } else {
        print('Профиль пуст');
        _error = 'Не удалось получить профиль';
        _isAuthenticated = false;
      }
    } catch (e) {
      print('Ошибка логина: $e');
      _error = e.toString();
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Начинаю регистрацию: $username, $email');
      await _authService.register(
        username,
        email,
        password,
        firstName: firstName,
        lastName: lastName,
      );
      print('Регистрация успешна, начинаю логин');

      await login(email, password);
    } catch (e) {
      print('Ошибка регистрации: $e');
      _error = e.toString();
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _user = null;
    _isAuthenticated = false;

    _isLoading = false;
    notifyListeners();
  }
}
