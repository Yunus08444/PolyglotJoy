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
  void initState() {
    super.initState();

    // ✅ безопасный вызов после build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loaded) {
        _loaded = true;
        final testId = ModalRoute.of(context)!.settings.arguments as int;
        context.read<TestProvider>().loadQuestions(testId);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ❌ оставили пустым (убрали вызов)
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
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A2C3E),
        title: Consumer<TestProvider>(
          builder: (context, tests, _) {
            final total = tests.currentQuestions.length;
            final current = tests.currentQuestionIndex + 1;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Вопрос $current из $total',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Consumer<TestProvider>(
        builder: (context, tests, _) {
          if (tests.isLoading) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFE), Colors.white],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF2EC4B6),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Загрузка вопросов...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C7A8E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (tests.error != null) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFE), Colors.white],
                ),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: const Color(0xFFE76F51),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка: ${tests.error}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE76F51),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final question = tests.currentQuestion;

          if (question == null) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFE), Colors.white],
                ),
              ),
              child: const Center(
                child: Text(
                  'Вопрос не найден',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6C7A8E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF8FAFE), Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Современный индикатор прогресса
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9ECEF),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: (tests.currentQuestionIndex + 1) / tests.currentQuestions.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2EC4B6), Color(0xFF20A090)],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(((tests.currentQuestionIndex + 1) / tests.currentQuestions.length) * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2EC4B6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Карточка вопроса с современным дизайном
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Иконка вопроса
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2EC4B6), Color(0xFF20A090)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.quiz_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              color: Color(0xFF1A2C3E),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Варианты ответов
                          ...List.generate(question.answers.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.circular(16),
                                color: selectedAnswer == index
                                    ? const Color(0xFF2EC4B6).withOpacity(0.08)
                                    : Colors.transparent,
                                child: InkWell(
                                  onTap: () => setState(() => selectedAnswer = index),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedAnswer == index
                                            ? const Color(0xFF2EC4B6)
                                            : const Color(0xFFE9ECEF),
                                        width: selectedAnswer == index ? 2 : 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      color: selectedAnswer == index
                                          ? const Color(0xFF2EC4B6).withOpacity(0.05)
                                          : Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: selectedAnswer == index
                                                  ? const Color(0xFF2EC4B6)
                                                  : const Color(0xFFCBD5E1),
                                              width: 2,
                                            ),
                                            color: selectedAnswer == index
                                                ? const Color(0xFF2EC4B6)
                                                : Colors.transparent,
                                          ),
                                          child: selectedAnswer == index
                                              ? const Icon(
                                                  Icons.check_rounded,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            question.answers[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: selectedAnswer == index
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: selectedAnswer == index
                                                  ? const Color(0xFF2EC4B6)
                                                  : const Color(0xFF2C3E50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Кнопка с современным дизайном
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (selectedAnswer >= 0)
                          BoxShadow(
                            color: const Color(0xFF2EC4B6).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: selectedAnswer >= 0 ? _next : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC4B6),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE9ECEF),
                        disabledForegroundColor: const Color(0xFFADB5BD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: selectedAnswer >= 0 ? 4 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tests.isTestCompleted ? 'Завершить тест' : 'Следующий вопрос',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (!tests.isTestCompleted && selectedAnswer >= 0)
                            const SizedBox(width: 8),
                          if (!tests.isTestCompleted && selectedAnswer >= 0)
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}