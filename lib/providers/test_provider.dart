import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../models/question_model.dart';
import '../services/api/test_service.dart';

class TestProvider extends ChangeNotifier {
  final TestService _testService;
  bool _isLoading = false;
  List<Test> _tests = [];
  List<Question> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _error;

  TestProvider({TestService? testService})
    : _testService = testService ?? TestService();

  bool get isLoading => _isLoading;
  List<Test> get tests => _tests;
  List<Question> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get correctAnswers => _correctAnswers;
  String? get error => _error;
  bool get isTestCompleted => _currentQuestionIndex >= _currentQuestions.length;
  Question? get currentQuestion =>
      _currentQuestions.isNotEmpty &&
          _currentQuestionIndex < _currentQuestions.length
      ? _currentQuestions[_currentQuestionIndex]
      : null;

  Future<void> loadTests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tests = await _testService.fetchTests();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuestions(int testId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _currentQuestions = await _testService.fetchQuestions(testId);
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
    } catch (e) {
      _error = e.toString();
      _currentQuestions = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void answerQuestion(int selectedIndex) {
    if (currentQuestion != null &&
        selectedIndex == currentQuestion!.correctIndex) {
      _correctAnswers++;
    }
    _currentQuestionIndex++;
    notifyListeners();
  }

  void resetTest() {
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _error = null;
    notifyListeners();
  }
}
