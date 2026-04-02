import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  late final ApiClient _client;
  late final FlutterSecureStorage _secureStorage;

  AuthService({ApiClient? client, FlutterSecureStorage? secureStorage})
    : _client = client ?? ApiClient(),
      _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    // Provide ApiClient with a callback to refresh tokens when a 401 occurs.
    _client.setRefreshTokenCallback(() => refreshToken());
  }

  /// Initialize AuthService by loading any persisted token into ApiClient.
  Future<void> initialize() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      _client.setAuthToken(token);
    }
  }

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

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final accessToken = data['access'];
        final refreshToken = data['refresh'];

        if (accessToken != null && refreshToken != null) {
          await _secureStorage.write(key: _accessTokenKey, value: accessToken);
          await _secureStorage.write(
            key: _refreshTokenKey,
            value: refreshToken,
          );
          _client.setAuthToken(accessToken);
        }
        return data;
      } else {
        throw Exception('Ошибка входа: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Неверный email или пароль');
      }
      throw Exception('Ошибка соединения: ${e.message}');
    } catch (e) {
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
          if (firstName != null && firstName.isNotEmpty)
            'first_name': firstName,
          if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
        },
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Ошибка регистрации: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response?.data as Map;
        if (errorData.containsKey('username')) {
          throw Exception('Пользователь с таким именем уже существует');
        } else if (errorData.containsKey('email')) {
          throw Exception('Пользователь с таким email уже существует');
        }
      }
      throw Exception('Ошибка регистрации: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    _client.clearAuthToken();
  }

  /// Попытаться обновить access token используя refresh token.
  /// Возвращает true, если обновление прошло успешно и токен сохранён.
  Future<bool> refreshToken() async {
    final refresh = await _secureStorage.read(key: _refreshTokenKey);
    if (refresh == null || refresh.isEmpty) {
      await logout();
      return false;
    }

    try {
      final response = await _client.dio.post(
        '/token/refresh/',
        data: {'refresh': refresh},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        // допустимые ключи зависят от реализации сервера
        final accessToken =
            data['access'] ?? data['access_token'] ?? data['token'];
        if (accessToken != null && accessToken is String) {
          await _secureStorage.write(key: _accessTokenKey, value: accessToken);
          _client.setAuthToken(accessToken);
          return true;
        }
      }

      await logout();
      return false;
    } on DioException catch (_) {
      await logout();
      return false;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final response = await _client.dio.get(
        '/users/me/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Не авторизован');

    final Map<String, dynamic> data = {};
    if (firstName != null && firstName.isNotEmpty) {
      data['first_name'] = firstName;
    }
    if (lastName != null && lastName.isNotEmpty) {
      data['last_name'] = lastName;
    }

    final response = await _client.dio.patch(
      '/users/me/',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка обновления профиля');
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Не авторизован');

    final response = await _client.dio.get(
      '/users/me/stats/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка получения статистики');
    }
  }

  Future<Map<String, dynamic>> updatePreferences({
    String? currentLanguage,
    String? learningLanguage,
    String? level,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Не авторизован');

    final Map<String, dynamic> data = {};
    if (currentLanguage != null) data['current_language'] = currentLanguage;
    if (learningLanguage != null) data['learning_language'] = learningLanguage;
    if (level != null) data['level'] = level;

    final response = await _client.dio.patch(
      '/users/me/preferences/',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка обновления предпочтений');
    }
  }

  Future<Map<String, dynamic>> updateProgress({
    required int pointsEarned,
    bool completedLesson = false,
    bool completedTest = false,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Не авторизован');

    final response = await _client.dio.post(
      '/users/me/stats/',
      data: {
        'points_earned': pointsEarned,
        'completed_lesson': completedLesson,
        'completed_test': completedTest,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка обновления прогресса');
    }
  }
}
