import 'package:dio/dio.dart';
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
    final token = await _authService.getToken();
    final response = await _client.dio.get(
      '/tests/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return data.map((item) {
        final map = item as Map<String, dynamic>;
        return Test.fromJson(map);
      }).toList();
    }

    throw Exception(
      'Не удалось получить список тестов: ${response.statusCode}',
    );
  }

  Future<List<Question>> fetchQuestions(int testId) async {
    final token = await _authService.getToken();
    final response = await _client.dio.get(
      '/tests/$testId/questions/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return data.map((item) {
        final map = item as Map<String, dynamic>;
        return Question.fromJson(map);
      }).toList();
    }

    throw Exception(
      'Не удалось получить вопросы теста: ${response.statusCode}',
    );
  }
}
