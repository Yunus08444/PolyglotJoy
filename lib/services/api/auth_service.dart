import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _client;
  final FlutterSecureStorage _secureStorage;

  AuthService({ApiClient? client, FlutterSecureStorage? secureStorage})
    : _client = client ?? ApiClient(),
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<Map<String, dynamic>> login(
    String usernameOrEmail,
    String password,
  ) async {
    try {
      final response = await _client.dio.post(
        '/token/',
        data: {'username': usernameOrEmail, 'password': password},
      );

      print('Login response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        await _secureStorage.write(key: _accessTokenKey, value: data['access']);
        await _secureStorage.write(
          key: _refreshTokenKey,
          value: data['refresh'],
        );
        return data;
      } else {
        final errorMsg = response.data is Map
            ? response.data['detail'] ?? 'Неверный пароль или пользователь'
            : 'Ошибка входа';
        throw Exception('Ошибка входа: $errorMsg');
      }
    } catch (e) {
      print('Ошибка при логине: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _client.dio.post(
        '/users/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      print('Register response status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        final errorData = response.data;
        String errorMsg = 'Ошибка регистрации';
        if (errorData is Map) {
          if (errorData.containsKey('username')) {
            errorMsg = 'Username уже используется: ${errorData['username']}';
          } else if (errorData.containsKey('email')) {
            errorMsg = 'Email уже используется: ${errorData['email']}';
          } else if (errorData.containsKey('password')) {
            errorMsg = 'Слабый пароль: ${errorData['password']}';
          } else {
            errorMsg = errorData.toString();
          }
        }
        throw Exception('Ошибка регистрации: $errorMsg');
      }
    } catch (e) {
      print('Ошибка при регистрации: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> saveToken(String token, String refreshToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await _client.dio.get(
        '/users/me/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      print('getCurrentUser status: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Ошибка получения профиля: $e');
      return null;
    }
  }
}
