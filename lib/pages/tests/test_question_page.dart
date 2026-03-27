import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';

class TestQuestionPage extends StatefulWidget {
  const TestQuestionPage({super.key});

  @override
  State<TestQuestionPage> createState() => _TestQuestionPageState();
}

class _TestQuestionPageState extends State<TestQuestionPage> {
  int selectedAnswer = -1;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final testId = ModalRoute.of(context)!.settings.arguments as int;
      context.read<TestProvider>().loadQuestions(testId);
    }
  }

  void _next() {
    if (selectedAnswer >= 0) {
      context.read<TestProvider>().answerQuestion(selectedAnswer);
      selectedAnswer = -1;
      if (context.read<TestProvider>().isTestCompleted) {
        Navigator.pushNamed(context, '/result');
      } else {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TestProvider>(
          builder: (context, tests, _) {
            final total = tests.currentQuestions.length;
            final current = tests.currentQuestionIndex + 1;
            return Text('Вопрос $current из $total');
          },
        ),
      ),
      body: Consumer<TestProvider>(
        builder: (context, tests, _) {
          if (tests.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tests.error != null) {
            return Center(child: Text('Ошибка: ${tests.error}'));
          }
          final question = tests.currentQuestion;
          if (question == null) {
            return const Center(child: Text('Вопрос не найден'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value:
                      (tests.currentQuestionIndex + 1) /
                      tests.currentQuestions.length,
                  color: const Color(0xFF2EC4B6),
                  backgroundColor: const Color(0xFFEAF8F6),
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(question.answers.length, (index) {
                          return RadioListTile<int>(
                            value: index,
                            groupValue: selectedAnswer,
                            title: Text(question.answers[index]),
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: const Color(0xFF2EC4B6),
                            onChanged: (value) =>
                                setState(() => selectedAnswer = value ?? -1),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedAnswer >= 0 ? _next : null,
                    child: Text(tests.isTestCompleted ? 'Завершить' : 'Далее'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
