import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: Consumer<TestProvider>(
        builder: (context, tests, _) {
          final total = tests.currentQuestions.length;
          final correct = tests.correctAnswers;
          final percentage = total > 0 ? correct / total : 0.0;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        percentage >= 0.8
                            ? 'Отличная работа!'
                            : percentage >= 0.6
                            ? 'Хороший результат!'
                            : 'Попробуйте еще раз!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Вы правильно ответили на $correct из $total вопросов',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: percentage,
                          strokeWidth: 10,
                          color: percentage >= 0.8
                              ? const Color(0xFF1DB954)
                              : percentage >= 0.6
                              ? const Color(0xFFFFB347)
                              : const Color(0xFFDE3C4B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            tests.resetTest();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          },
                          child: const Text('Вернуться на главную'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
