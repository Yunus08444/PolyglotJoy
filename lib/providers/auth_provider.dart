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

    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        _isAuthenticated = false;
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userJson = await _authService.getCurrentUser();
      if (userJson != null && userJson.isNotEmpty) {
        _user = User.fromJson(userJson);
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _user = null;
      }
    } catch (e) {
      debugPrint('Error in tryAutoLogin: $e');
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Начинаю логин с: $email');
      await _authService.login(email, password);
      debugPrint('JWT токен получен');

      final profile = await _authService.getCurrentUser();
      if (profile != null && profile.isNotEmpty) {
        debugPrint('Профиль получен: $profile');
        _user = User.fromJson(profile);
        _isAuthenticated = true;
      } else {
        debugPrint('Профиль пуст');
        _error = 'Не удалось получить профиль';
        _isAuthenticated = false;
      }
    } catch (e) {
      debugPrint('Ошибка логина: $e');
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      debugPrint('Начинаю регистрацию: $username, $email');
      await _authService.register(
        username,
        email,
        password,
        firstName: firstName,
        lastName: lastName,
      );
      debugPrint('Регистрация успешна, начинаю логин');

      await login(email, password);
    } catch (e) {
      debugPrint('Ошибка регистрации: $e');
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
