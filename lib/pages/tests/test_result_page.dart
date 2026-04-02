import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A2C3E),
        title: const Text(
          'Результаты теста',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2C3E),
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<TestProvider>(
        builder: (context, tests, _) {
          final total = tests.currentQuestions.length;
          final correct = tests.correctAnswers;
          final percentage = total > 0 ? correct / total : 0.0;
          final percentValue = (percentage * 100).toInt();

          // Определение статуса и сообщения
          String title;
      String emoji;
      Color mainColor;
      IconData statusIcon;

      if (percentage >= 0.8) {
        title = 'Отлично!';
        emoji = '🌟';
        mainColor = const Color(0xFF2EC4B6);
        statusIcon = Icons.emoji_events_rounded;
      } else if (percentage >= 0.6) {
        title = 'Хорошо!';
        emoji = '👍';
        mainColor = const Color(0xFFFFB347);
        statusIcon = Icons.thumb_up_rounded;
      } else {
        title = 'Попробуйте ещё раз';
        emoji = '💪';
        mainColor = const Color(0xFFE76F51);
        statusIcon = Icons.fitness_center_rounded;
      }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Анимированная карточка результата
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            mainColor.withOpacity(0.1),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          children: [
                            // Иконка статуса
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [mainColor, mainColor.withOpacity(0.7)],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: mainColor.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                statusIcon,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Текст результата
                            Text(
                              '$title $emoji',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Вы правильно ответили на $correct из $total вопросов',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6C7A8E),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Круговой индикатор с процентом
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween<double>(begin: 0, end: percentage),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Container(
                        width: 180,
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: 12,
                                backgroundColor: const Color(0xFFE9ECEF),
                                color: mainColor,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(value * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'верных ответов',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFADB5BD),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Детальная статистика
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2EC4B6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF2EC4B6),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Правильные ответы',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6C7A8E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$correct / $total',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A2C3E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE76F51).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.cancel_rounded,
                                color: Color(0xFFE76F51),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Неправильные ответы',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6C7A8E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${total - correct} / $total',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A2C3E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Кнопка возврата
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        tests.resetTest();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.home_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Вернуться на главную',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Дополнительная кнопка для повторного прохождения
                  TextButton(
                    onPressed: () {
                      tests.resetTest();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: mainColor,
                    ),
                    child: const Text(
                      'Пройти тест заново',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}