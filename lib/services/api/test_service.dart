import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/test_model.dart';
import '../../models/question_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class TestService {
  final ApiClient _client;
  final AuthService _authService;

  TestService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient(),
      _authService = authService ?? AuthService();

  Future<List<Test>> fetchTests() async {
    Future<List<Test>> doFetch() async {
      final token = await _authService.getToken();
      final response = await _client.dio.get(
        '/tests/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        List<dynamic> dataList;

        if (raw is List) {
          dataList = raw;
        } else if (raw is Map<String, dynamic>) {
          if (raw['results'] is List) {
            dataList = raw['results'] as List<dynamic>;
          } else if (raw['data'] is List) {
            dataList = raw['data'] as List<dynamic>;
          } else if (raw['tests'] is List) {
            dataList = raw['tests'] as List<dynamic>;
          } else {
            // Unexpected shape: try to find the first list value
            final maybeList = raw.values.firstWhere(
              (v) => v is List,
              orElse: () => <dynamic>[],
            );
            dataList = maybeList as List<dynamic>;
          }
        } else {
          dataList = <dynamic>[];
        }

        // Debug log to help diagnose empty responses
        debugPrint(
          '📦 fetchTests: status=${response.statusCode} path=${response.requestOptions.path} parsed=${dataList.length} type=${response.data.runtimeType}',
        );
        try {
          debugPrint('📦 fetchTests: raw=${response.data}');
        } catch (_) {}

        return dataList.map((item) {
          final map = item as Map<String, dynamic>;
          return Test.fromJson(map);
        }).toList();
      }

      throw Exception(
        'Не удалось получить список тестов: ${response.statusCode}',
      );
    }

    try {
      return await doFetch();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await _authService.refreshToken();
        if (refreshed) {
          return await doFetch();
        }
      }
      rethrow;
    }
  }

  Future<List<Question>> fetchQuestions(int testId) async {
    Future<List<Question>> doFetch() async {
      final token = await _authService.getToken();
      final response = await _client.dio.get(
        '/tests/$testId/questions/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        List<dynamic> dataList;

        if (raw is List) {
          dataList = raw;
        } else if (raw is Map<String, dynamic>) {
          if (raw['results'] is List) {
            dataList = raw['results'] as List<dynamic>;
          } else if (raw['data'] is List) {
            dataList = raw['data'] as List<dynamic>;
          } else if (raw['questions'] is List) {
            dataList = raw['questions'] as List<dynamic>;
          } else {
            final maybeList = raw.values.firstWhere(
              (v) => v is List,
              orElse: () => <dynamic>[],
            );
            dataList = maybeList as List<dynamic>;
          }
        } else {
          dataList = <dynamic>[];
        }

        debugPrint(
          '📦 fetchQuestions: status=${response.statusCode} path=${response.requestOptions.path} parsed=${dataList.length} type=${response.data.runtimeType}',
        );
        try {
          debugPrint('📦 fetchQuestions: raw=${response.data}');
        } catch (_) {}

        return dataList.map((item) {
          final map = item as Map<String, dynamic>;
          return Question.fromJson(map);
        }).toList();
      }

      throw Exception(
        'Не удалось получить вопросы теста: ${response.statusCode}',
      );
    }

    try {
      return await doFetch();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await _authService.refreshToken();
        if (refreshed) {
          return await doFetch();
        }
      }
      rethrow;
    }
  }

  /// Logout helper to clear stored tokens (used when API returns 401)
  Future<void> logout() async {
    await _authService.logout();
  }
}
