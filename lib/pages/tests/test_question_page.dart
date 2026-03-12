import 'package:flutter/material.dart';

class TestQuestionPage extends StatefulWidget {
  const TestQuestionPage({super.key});

  @override
  State<TestQuestionPage> createState() => _TestQuestionPageState();
}

class _TestQuestionPageState extends State<TestQuestionPage> {
  int selectedAnswer = -1;

  void _next() {
    if (selectedAnswer >= 0) {
      Navigator.pushNamed(context, '/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вопрос 1 из 5')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: 0.2,
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
                    const Text(
                      'Как переводится слово "apple"? ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(4, (index) {
                      final option = [
                        'Яблоко',
                        'Апельсин',
                        'Банан',
                        'Груша',
                      ][index];
                      return RadioListTile<int>(
                        value: index,
                        groupValue: selectedAnswer,
                        title: Text(option),
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
                onPressed: _next,
                child: const Text('Далее'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
