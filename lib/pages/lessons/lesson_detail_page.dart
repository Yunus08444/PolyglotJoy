import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import '../../services/api/auth_service.dart';

class LessonListPage extends StatefulWidget {
  const LessonListPage({super.key});

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  late AuthService _authService;
  List<Map<String, dynamic>> lessons = [];
  bool isLoading = true;

  // Маппинг для приведения названий к правильному формату
  final Map<String, String> titleMapping = {
    'Основы': 'Урок 1: Основы',
    'Грамматика': 'Урок 2: Грамматика',
    'Словарь': 'Урок 3: Словарь',
    'Разговорная': 'Урок 4: Разговорная практика',
    'Аудирование': 'Урок 5: Аудирование',
    'Письмо': 'Урок 6: Письмо',
    'Чтение': 'Урок 7: Чтение',
    'Культура': 'Урок 8: Культура и традиции',
  };

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      final data = await _authService.getLessons();
      // Приводим названия уроков к правильному формату
      for (var lesson in data) {
        final originalTitle = lesson['title'] ?? '';
        String? newTitle;
        for (var key in titleMapping.keys) {
          if (originalTitle.contains(key)) {
            newTitle = titleMapping[key];
            break;
          }
        }
        if (newTitle != null) {
          lesson['title'] = newTitle;
        }
      }
      setState(() {
        lessons = data;
        isLoading = false;
      });
      debugPrint('✅ Loaded ${lessons.length} lessons');
    } catch (e) {
      debugPrint('❌ Error loading lessons: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Мои уроки',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1A1A2E),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6366F1),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Загрузка уроков...',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final isCompleted = lesson['is_completed'] ?? false;
                final gradientColors = _getGradientColors(
                  lesson['title'] ?? '',
                );
                final icon = _getLessonIcon(lesson['title'] ?? '');

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: lesson,
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(icon, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lesson['title'] ?? 'Урок',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lesson['subtitle'] ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Пройден',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 16,
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

  List<Color> _getGradientColors(String title) {
    if (title.contains('Основы')) {
      return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    } else if (title.contains('Грамматика')) {
      return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
    } else if (title.contains('Словарь')) {
      return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
    } else if (title.contains('Разговорная практика')) {
      return [const Color(0xFF10B981), const Color(0xFF34D399)];
    } else if (title.contains('Аудирование')) {
      return [const Color(0xFFF59E0B), const Color(0xFFEF4444)];
    } else if (title.contains('Письмо')) {
      return [const Color(0xFF8B5CF6), const Color(0xFFD946EF)];
    } else if (title.contains('Чтение')) {
      return [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)];
    } else if (title.contains('Культура')) {
      return [const Color(0xFFF97316), const Color(0xFFFBBF24)];
    }
    return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
  }

  IconData _getLessonIcon(String title) {
    if (title.contains('Основы')) {
      return Icons.auto_stories_rounded;
    } else if (title.contains('Грамматика')) {
      return Icons.abc_rounded;
    } else if (title.contains('Словарь')) {
      return Icons.menu_book_rounded;
    } else if (title.contains('Разговорная')) {
      return Icons.record_voice_over_rounded;
    } else if (title.contains('Аудирование')) {
      return Icons.headphones_rounded;
    } else if (title.contains('Письмо')) {
      return Icons.edit_note_rounded;
    } else if (title.contains('Чтение')) {
      return Icons.library_books_rounded;
    } else if (title.contains('Культура')) {
      return Icons.public_rounded;
    }
    return Icons.school_rounded;
  }
}

class LessonDetailPage extends StatefulWidget {
  const LessonDetailPage({super.key});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  late AuthService _authService;
  Map<String, dynamic>? lesson;
  late List<Map<String, dynamic>> exercises;
  int currentIndex = 0;
  int correctAnswers = 0;
  List<int> wrongIndexes = [];

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      Navigator.pop(context);
      return;
    }
    lesson = args;
    var allExercises = _getLessonExercises(lesson!['title'] ?? 'Default');
    allExercises.shuffle(Random());
    exercises = allExercises.take(12).toList();
    exercises.shuffle(Random());
    debugPrint('✅ Selected ${exercises.length} random questions for lesson');
  }

  Future<void> _completeLesson() async {
    try {
      if (lesson != null && lesson!['id'] != null) {
        await _authService.completeLesson(lesson!['id']);
        debugPrint('✅ Lesson marked as completed');
      }
    } catch (e) {
      debugPrint('❌ Error marking lesson complete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final gradientColors = _getGradientColors(lesson!['title'] ?? '');
    final icon = _getLessonIcon(lesson!['title'] ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF1A1A2E),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lesson!['title'] ?? 'Урок',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      blurRadius: 12,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                    ),
                  ),
                  ..._buildBackgroundCircles(),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(icon, size: 64, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          lesson!['title'] ?? 'Урок',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            lesson!['subtitle'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: _buildExercise(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return [
      Positioned(
        top: -80,
        right: -80,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
          ),
        ),
      ),
      Positioned(
        bottom: -100,
        left: -50,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ),
      Positioned(
        top: 100,
        left: -30,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
    ];
  }

  Widget _buildExercise() {
    if (currentIndex >= exercises.length) {
      final scorePercent = (correctAnswers / exercises.length * 100).round();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scorePercent >= 70
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              scorePercent >= 70
                  ? Icons.emoji_events_rounded
                  : Icons.school_rounded,
              size: 64,
              color: scorePercent >= 70
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            scorePercent >= 70 ? 'Отлично!' : 'Хорошая попытка!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Правильных ответов: $correctAnswers из ${exercises.length}',
            style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scorePercent >= 70
                  ? Colors.green.shade100
                  : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$scorePercent%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: scorePercent >= 70
                    ? Colors.green.shade800
                    : Colors.orange.shade800,
              ),
            ),
          ),
          if (wrongIndexes.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Разбор ошибок',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...wrongIndexes.map(
              (i) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вопрос ${i + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercises[i]['question'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '✅ Правильный ответ: ${exercises[i]['answer']}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () async {
              await _completeLesson();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Вернуться к урокам',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    final exercise = exercises[currentIndex];
    var options = List<String>.from(exercise['options'] as List);
    options.shuffle(Random());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Вопрос ${currentIndex + 1}/${exercises.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${((currentIndex + 1) / exercises.length * 100).round()}%',
              style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: (currentIndex + 1) / exercises.length,
          backgroundColor: const Color(0xFFE5E7EB),
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(10),
          minHeight: 6,
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            exercise['question'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 28),
        ...options.map<Widget>((opt) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (opt == exercise['answer']) {
                    correctAnswers++;
                  } else {
                    wrongIndexes.add(currentIndex);
                  }
                  currentIndex++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1F2937),
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + options.indexOf(opt)),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      opt,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  List<Map<String, dynamic>> _getLessonExercises(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return [
          {
            'question': 'Какая буква идёт первой в английском алфавите?',
            'options': ['A', 'B', 'C', 'D'],
            'answer': 'A',
          },
          {
            'question': 'Как поприветствовать друга неформально?',
            'options': ['Hi', 'Good morning', 'Bye', 'Thanks'],
            'answer': 'Hi',
          },
          {
            'question': 'Как сказать "Спасибо"?',
            'options': ['Hello', 'Please', 'Thank you', 'Sorry'],
            'answer': 'Thank you',
          },
          {
            'question': 'Какая гласная буква?',
            'options': ['B', 'E', 'L', 'S'],
            'answer': 'E',
          },
          {
            'question': 'Прощание формальное?',
            'options': ['Bye', 'See you', 'Good evening', 'Hey'],
            'answer': 'Good evening',
          },
          {
            'question': 'Сколько букв в английском алфавите?',
            'options': ['24', '26', '25', '27'],
            'answer': '26',
          },
          {
            'question': 'Как спросить "Как дела?" формально?',
            'options': ['How are you?', 'Yo!', 'Sup?', 'Hi'],
            'answer': 'How are you?',
          },
          {
            'question': 'Звуки /θ/ и /ð/ встречаются в словах?',
            'options': [
              'think и this',
              'cat и dog',
              'sun и moon',
              'apple и orange',
            ],
            'answer': 'think и this',
          },
          {
            'question': 'Как сказать "Доброе утро"?',
            'options': [
              'Good night',
              'Good morning',
              'Good evening',
              'Good afternoon',
            ],
            'answer': 'Good morning',
          },
          {
            'question': 'Как сказать "Пожалуйста" (просьба)?',
            'options': ['Thank you', 'Sorry', 'Please', 'You\'re welcome'],
            'answer': 'Please',
          },
          {
            'question': 'Какая буква последняя в алфавите?',
            'options': ['X', 'Y', 'Z', 'W'],
            'answer': 'Z',
          },
          {
            'question': 'Как сказать "Извините"?',
            'options': ['Please', 'Thank you', 'Sorry', 'Hello'],
            'answer': 'Sorry',
          },
          {
            'question': 'Как звучит буква "C"?',
            'options': ['Си', 'Ка', 'Се', 'Си-и'],
            'answer': 'Си',
          },
          {
            'question': 'Сколько гласных букв в алфавите?',
            'options': ['5', '6', '7', '8'],
            'answer': '5',
          },
          {
            'question': 'Что значит "Good night"?',
            'options': [
              'Добрый день',
              'Добрый вечер',
              'Спокойной ночи',
              'Доброе утро',
            ],
            'answer': 'Спокойной ночи',
          },
          {
            'question': 'Как поздороваться в письме?',
            'options': ['Bye', 'Dear Sir', 'Hello', 'Goodbye'],
            'answer': 'Dear Sir',
          },
          {
            'question': 'Что означает "Please"?',
            'options': ['Спасибо', 'Пожалуйста', 'Привет', 'До встречи'],
            'answer': 'Пожалуйста',
          },
          {
            'question': 'Правильное произношение "Thank you"?',
            'options': ['Зенк ю', 'Тенк ю', 'Синк ю', 'Танк ю'],
            'answer': 'Зенк ю',
          },
          {
            'question': 'Как сказать "You\'re welcome"?',
            'options': [
              'До встречи',
              'Добро пожаловать',
              'Пожалуйста',
              'Спасибо',
            ],
            'answer': 'Пожалуйста',
          },
          {
            'question': 'Как звучит "How do you do?"?',
            'options': ['Привет', 'Как удалась?', 'Как ваши дела?', 'Кто вы?'],
            'answer': 'Как ваши дела?',
          },
          {
            'question': 'Что значит буква Y в конце алфавита?',
            'options': ['Вай', 'Уай', 'Уи', 'Йи'],
            'answer': 'Уай',
          },
          {
            'question': 'Как на английский "До свидания"?',
            'options': ['See you', 'Hello', 'Good morning', 'Goodbye'],
            'answer': 'Goodbye',
          },
          {
            'question': 'Сколько согласных в "Hello"?',
            'options': ['1', '2', '3', '4'],
            'answer': '3',
          },
          {
            'question': 'Что означает "My name is..."?',
            'options': ['Мне нравится', 'Меня зовут', 'Я люблю', 'Я хочу'],
            'answer': 'Меня зовут',
          },
        ];

      case 'Урок 2: Грамматика':
        return [
          {
            'question': 'I ___ happy.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'am',
          },
          {
            'question': 'Выберите правильное личное местоимение для "мы"',
            'options': ['I', 'We', 'You', 'They'],
            'answer': 'We',
          },
          {
            'question': 'Вопросительная форма "Ты учитель?"',
            'options': [
              'Are you a teacher?',
              'You are teacher?',
              'Am you teacher?',
              'Is you teacher?',
            ],
            'answer': 'Are you a teacher?',
          },
          {
            'question': 'Отрицательная форма "I am not"',
            'options': ['I am not', 'I not am', 'I is not', 'I are not'],
            'answer': 'I am not',
          },
          {
            'question': 'Перевод слова "She"',
            'options': ['Он', 'Она', 'Мы', 'Вы'],
            'answer': 'Она',
          },
          {
            'question': 'Правильный порядок слов в утверждении',
            'options': ['S+V+O', 'V+S+O', 'O+S+V', 'S+O+V'],
            'answer': 'S+V+O',
          },
          {
            'question': 'Вопросительное слово "Где?"',
            'options': ['What', 'Where', 'Why', 'How'],
            'answer': 'Where',
          },
          {
            'question': 'Как сказать "они студенты"?',
            'options': [
              'They is students',
              'They are students',
              'They be students',
              'They am students',
            ],
            'answer': 'They are students',
          },
          {
            'question': 'He ___ a doctor.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'is',
          },
          {
            'question': 'Вопросительное слово "Почему?"',
            'options': ['What', 'Where', 'Why', 'When'],
            'answer': 'Why',
          },
          {
            'question': 'She ___ my friend.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'is',
          },
          {
            'question': 'Как сказать "Это моя книга"?',
            'options': [
              'This is my book',
              'This my book',
              'Is this my book',
              'My book this is',
            ],
            'answer': 'This is my book',
          },
          {
            'question': 'You ___ students.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'are',
          },
          {
            'question': 'Что такое "to be"?',
            'options': ['Делать', 'Быть', 'Идти', 'Говорить'],
            'answer': 'Быть',
          },
          {
            'question': 'We ___ friends.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'are',
          },
          {
            'question': 'Как спросить "Ты доктор?"',
            'options': [
              'You are doctor?',
              'Are you a doctor?',
              'Is you doctor?',
              'You is doctor?',
            ],
            'answer': 'Are you a doctor?',
          },
          {
            'question': 'Что означает "to be" в 3 лице?',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'is',
          },
          {
            'question': 'It ___ a cat.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'is',
          },
          {
            'question': 'Как сказать "Мы не студенты"?',
            'options': [
              'We not are students',
              'We are not students',
              'We is not students',
              'We am not students',
            ],
            'answer': 'We are not students',
          },
          {
            'question': 'Что означает "They are engineers"?',
            'options': [
              'Они методисты',
              'Они инженеры',
              'Они актеры',
              'Они учителя',
            ],
            'answer': 'Они инженеры',
          },
          {
            'question': 'Как сказать "Я студент"?',
            'options': [
              'I are student',
              'I is student',
              'I am a student',
              'I be student',
            ],
            'answer': 'I am a student',
          },
          {
            'question': 'Какое местоимение для одного мужчины?',
            'options': ['She', 'He', 'It', 'They'],
            'answer': 'He',
          },
          {
            'question': 'Вопросительное слово "Что?"',
            'options': ['What', 'Where', 'When', 'Who'],
            'answer': 'What',
          },
          {
            'question': 'He and she ___ students.',
            'options': ['am', 'is', 'are', 'be'],
            'answer': 'are',
          },
        ];

      case 'Урок 3: Словарь':
        return [
          {
            'question': 'Как будет "красный" по-английски?',
            'options': ['Red', 'Blue', 'Green', 'Yellow'],
            'answer': 'Red',
          },
          {
            'question': 'Как будет "яблоко"?',
            'options': ['Apple', 'Orange', 'Banana', 'Grape'],
            'answer': 'Apple',
          },
          {
            'question': 'Как сказать "мама"?',
            'options': ['Dad', 'Mother', 'Sister', 'Brother'],
            'answer': 'Mother',
          },
          {
            'question': 'Как будет "собака"?',
            'options': ['Cat', 'Dog', 'Bird', 'Fish'],
            'answer': 'Dog',
          },
          {
            'question': 'Как сказать "синий"?',
            'options': ['Red', 'Green', 'Blue', 'Yellow'],
            'answer': 'Blue',
          },
          {
            'question': 'Как будет "вода"?',
            'options': ['Milk', 'Juice', 'Water', 'Tea'],
            'answer': 'Water',
          },
          {
            'question': 'Как сказать "папа"?',
            'options': ['Mother', 'Sister', 'Brother', 'Father'],
            'answer': 'Father',
          },
          {
            'question': 'Как будет "кошка"?',
            'options': ['Dog', 'Cat', 'Bird', 'Fish'],
            'answer': 'Cat',
          },
          {
            'question': 'Как будет "зеленый"?',
            'options': ['Red', 'Blue', 'Green', 'Yellow'],
            'answer': 'Green',
          },
          {
            'question': 'Как сказать "хлеб"?',
            'options': ['Bread', 'Milk', 'Water', 'Meat'],
            'answer': 'Bread',
          },
          {
            'question': 'Как будет "солнце"?',
            'options': ['Moon', 'Star', 'Sun', 'Sky'],
            'answer': 'Sun',
          },
          {
            'question': 'Как сказать "радостный"?',
            'options': ['Sad', 'Happy', 'Tired', 'Angry'],
            'answer': 'Happy',
          },
          {
            'question': 'Как будет "черный"?',
            'options': ['Black', 'White', 'Gray', 'Brown'],
            'answer': 'Black',
          },
          {
            'question': 'Как сказать "белый"?',
            'options': ['Black', 'White', 'Gray', 'Brown'],
            'answer': 'White',
          },
          {
            'question': 'Как будет "цветок"?',
            'options': ['Tree', 'Flower', 'Grass', 'Plant'],
            'answer': 'Flower',
          },
          {
            'question': 'Как сказать "дерево"?',
            'options': ['Tree', 'Flower', 'Grass', 'Plant'],
            'answer': 'Tree',
          },
          {
            'question': 'Как будет "дом"?',
            'options': ['House', 'Home', 'Building', 'Room'],
            'answer': 'House',
          },
          {
            'question': 'Как сказать "книга"?',
            'options': ['Book', 'Paper', 'Magazine', 'Newspaper'],
            'answer': 'Book',
          },
          {
            'question': 'Как будет "ручка"?',
            'options': ['Pen', 'Pencil', 'Marker', 'Brush'],
            'answer': 'Pen',
          },
          {
            'question': 'Как сказать "стол"?',
            'options': ['Table', 'Chair', 'Desk', 'Bench'],
            'answer': 'Table',
          },
          {
            'question': 'Как будет "стул"?',
            'options': ['Table', 'Chair', 'Desk', 'Bench'],
            'answer': 'Chair',
          },
          {
            'question': 'Как сказать "время"?',
            'options': ['Time', 'Day', 'Hour', 'Minute'],
            'answer': 'Time',
          },
          {
            'question': 'Как будет "день"?',
            'options': ['Time', 'Day', 'Hour', 'Minute'],
            'answer': 'Day',
          },
          {
            'question': 'Как сказать "ночь"?',
            'options': ['Night', 'Evening', 'Morning', 'Afternoon'],
            'answer': 'Night',
          },
        ];

      case 'Урок 4: Разговорная практика':
        return [
          {
            'question': 'Как спросить "Как тебя зовут?"',
            'options': [
              'How are you?',
              'What is your name?',
              'Where are you?',
              'How old are you?',
            ],
            'answer': 'What is your name?',
          },
          {
            'question': 'Как ответить на "How are you?"',
            'options': ['My name is', 'I am fine', 'I am 20', 'I am from'],
            'answer': 'I am fine',
          },
          {
            'question': 'Как сказать "Приятно познакомиться"',
            'options': [
              'Good morning',
              'Nice to meet you',
              'How are you',
              'See you later',
            ],
            'answer': 'Nice to meet you',
          },
          {
            'question': 'Как спросить "Откуда ты?"',
            'options': [
              'Where are you?',
              'What are you?',
              'Where are you from?',
              'How are you?',
            ],
            'answer': 'Where are you from?',
          },
          {
            'question': 'Как сказать "До свидания"',
            'options': ['Hello', 'Hi', 'Goodbye', 'Thanks'],
            'answer': 'Goodbye',
          },
          {
            'question': 'Как спросить "Сколько тебе лет?"',
            'options': [
              'How are you?',
              'What is your name?',
              'How old are you?',
              'Where are you?',
            ],
            'answer': 'How old are you?',
          },
          {
            'question': 'Как сказать "Извините" (привлечь внимание)',
            'options': ['Sorry', 'Excuse me', 'Please', 'Thank you'],
            'answer': 'Excuse me',
          },
          {
            'question': 'Как ответить на "Thank you"',
            'options': ['Please', 'Sorry', 'You\'re welcome', 'Thanks'],
            'answer': 'You\'re welcome',
          },
          {
            'question': 'Как спросить "Который час?"',
            'options': [
              'What time is it?',
              'What is it?',
              'How time?',
              'When is it?',
            ],
            'answer': 'What time is it?',
          },
          {
            'question': 'Как сказать "Увидимся позже"',
            'options': ['Goodbye', 'See you later', 'Bye bye', 'Good night'],
            'answer': 'See you later',
          },
          {
            'question': 'Как спросить "Чем ты занимаешься?"',
            'options': [
              'What do you do?',
              'How do you do?',
              'What are you?',
              'Who are you?',
            ],
            'answer': 'What do you do?',
          },
          {
            'question': 'Как сказать "Хорошего дня!"',
            'options': [
              'Good morning',
              'Good night',
              'Have a nice day',
              'Good luck',
            ],
            'answer': 'Have a nice day',
          },
          {
            'question': 'Что ответить на "Nice to meet you"?',
            'options': [
              'Thank you',
              'Nice to meet you too',
              'How are you?',
              'I\'m fine',
            ],
            'answer': 'Nice to meet you too',
          },
          {
            'question': 'Как спросить "Какое твое имя?"',
            'options': [
              'What is your name?',
              'Who are you?',
              'Tell me your name',
              'Your name please',
            ],
            'answer': 'What is your name?',
          },
          {
            'question': 'Как сказать красиво "Мне очень приятно"?',
            'options': ['I am happy', 'I am glad', 'I am fine', 'I am good'],
            'answer': 'I am glad',
          },
          {
            'question': 'Как вежливо попросить помощь?',
            'options': ['Help me!', 'Can you help me?', 'Help!', 'I need help'],
            'answer': 'Can you help me?',
          },
          {
            'question': 'Как спросить "Как ваше дело?"',
            'options': [
              'How are you?',
              'How are you doing?',
              'How is it going?',
              'All variants are correct',
            ],
            'answer': 'All variants are correct',
          },
          {
            'question': 'Как сказать "Я согласен"?',
            'options': ['I agree', 'I don\'t agree', 'Yes', 'OK'],
            'answer': 'I agree',
          },
          {
            'question': 'Как выразить неудовольствие?',
            'options': [
              'I\'m happy',
              'I\'m satisfied',
              'I\'m not happy',
              'I\'m great',
            ],
            'answer': 'I\'m not happy',
          },
          {
            'question': 'Как спросить дорогу вежливо?',
            'options': [
              'Where is...?',
              'Can you tell me where is...?',
              'Where...?',
              'Excuse me, where is...?',
            ],
            'answer': 'Excuse me, where is...?',
          },
          {
            'question': 'Как пожелать удачи?',
            'options': ['Good luck', 'Good bye', 'See you', 'Hello'],
            'answer': 'Good luck',
          },
          {
            'question': 'Как вежливо отказаться?',
            'options': ['No', 'I can\'t', 'I\'m afraid I can\'t', 'No thanks'],
            'answer': 'I\'m afraid I can\'t',
          },
          {
            'question': 'Как выразить непонимание?',
            'options': ['I understand', 'I don\'t understand', 'Clear', 'OK'],
            'answer': 'I don\'t understand',
          },
          {
            'question': 'Как попросить повторить?',
            'options': [
              'Repeat!',
              'Can you repeat?',
              'Repeat please',
              'Can you repeat it please?',
            ],
            'answer': 'Can you repeat it please?',
          },
        ];

      case 'Урок 5: Аудирование':
        return [
          {
            'question': 'Что означает фраза "I don\'t understand"?',
            'options': ['Я понимаю', 'Я не понимаю', 'Я знаю', 'Я не знаю'],
            'answer': 'Я не понимаю',
          },
          {
            'question': 'Как звучит слово "Cat"?',
            'options': ['Кот', 'Собака', 'Мышь', 'Птица'],
            'answer': 'Кот',
          },
          {
            'question': 'Что означает "Can you repeat, please?"',
            'options': [
              'Можно выйти?',
              'Повторите пожалуйста',
              'Как дела?',
              'Спасибо',
            ],
            'answer': 'Повторите пожалуйста',
          },
          {
            'question': 'Как переводится "Slowly"?',
            'options': ['Быстро', 'Медленно', 'Громко', 'Тихо'],
            'answer': 'Медленно',
          },
          {
            'question': 'Что означает "Listen carefully"?',
            'options': [
              'Смотри внимательно',
              'Слушай внимательно',
              'Говори громко',
              'Пиши быстро',
            ],
            'answer': 'Слушай внимательно',
          },
          {
            'question': 'Как переводится "Loud"?',
            'options': ['Тихий', 'Громкий', 'Быстрый', 'Медленный'],
            'answer': 'Громкий',
          },
          {
            'question': 'Что означает "I can\'t hear you"?',
            'options': [
              'Я тебя вижу',
              'Я тебя слышу',
              'Я тебя не слышу',
              'Я тебя не вижу',
            ],
            'answer': 'Я тебя не слышу',
          },
          {
            'question': 'Как переводится "Pronunciation"?',
            'options': ['Грамматика', 'Словарь', 'Произношение', 'Чтение'],
            'answer': 'Произношение',
          },
          {
            'question': 'Что означает "Turn up the volume"?',
            'options': [
              'Выключи звук',
              'Убавь громкость',
              'Прибавь громкость',
              'Включи музыку',
            ],
            'answer': 'Прибавь громкость',
          },
          {
            'question': 'Как переводится "Accent"?',
            'options': ['Акцент', 'Диалект', 'Язык', 'Речь'],
            'answer': 'Акцент',
          },
          {
            'question': 'Что означает "I missed that"?',
            'options': ['Я понял', 'Я пропустил', 'Я запомнил', 'Я забыл'],
            'answer': 'Я пропустил',
          },
          {
            'question': 'Как переводится "Clearly"?',
            'options': ['Нечетко', 'Громко', 'Четко/ясно', 'Тихо'],
            'answer': 'Четко/ясно',
          },
          {
            'question': 'Что означает "Speak up"?',
            'options': ['Говори громче', 'Говори тише', 'Слушай', 'Повторяй'],
            'answer': 'Говори громче',
          },
          {
            'question': 'Как переводится "Fluently"?',
            'options': ['С ошибками', 'Бегло', 'Медленно', 'С акцентом'],
            'answer': 'Бегло',
          },
          {
            'question': 'Что означает "Articulate"?',
            'options': [
              'Невнятная речь',
              'Четкая речь',
              'Быстрая речь',
              'Медленная речь',
            ],
            'answer': 'Четкая речь',
          },
          {
            'question': 'Как переводится "Tone of voice"?',
            'options': ['Шум', 'Тон голоса', 'Звук', 'Музыка'],
            'answer': 'Тон голоса',
          },
          {
            'question': 'Что означает "Native speaker"?',
            'options': ['Иностранец', 'Носитель языка', 'Учитель', 'Студент'],
            'answer': 'Носитель языка',
          },
          {
            'question': 'Как переводится "Intonation"?',
            'options': ['Ритм', 'Интонация', 'Ударение', 'Мелодия'],
            'answer': 'Интонация',
          },
          {
            'question': 'Что означает "Mumble"?',
            'options': ['Говорить четко', 'Бормотать', 'Кричать', 'Шептать'],
            'answer': 'Бормотать',
          },
          {
            'question': 'Как переводится "Dialect"?',
            'options': ['Язык', 'Диалект', 'Речь', 'Слово'],
            'answer': 'Диалект',
          },
          {
            'question': 'Что означает "Turn down the volume"?',
            'options': [
              'Прибавь звук',
              'Убавь звук',
              'Выключи звук',
              'Включи звук',
            ],
            'answer': 'Убавь звук',
          },
          {
            'question': 'Как переводится "Slur"?',
            'options': [
              'Четкая речь',
              'Невнятная речь',
              'Быстрая речь',
              'Медленная речь',
            ],
            'answer': 'Невнятная речь',
          },
          {
            'question': 'Что означает "Pitch"?',
            'options': ['Громкость', 'Высота звука', 'Скорость', 'Тон'],
            'answer': 'Высота звука',
          },
          {
            'question': 'Как переводится "Rhythm"?',
            'options': ['Интонация', 'Ритм', 'Мелодия', 'Звук'],
            'answer': 'Ритм',
          },
        ];

      case 'Урок 6: Письмо':
        return [
          {
            'question': 'Как начать неформальное письмо другу?',
            'options': [
              'Dear Sir',
              'Hi',
              'To whom it may concern',
              'Hello Sir',
            ],
            'answer': 'Hi',
          },
          {
            'question': 'Как закончить формальное письмо?',
            'options': ['Love', 'Cheers', 'Yours sincerely', 'See you'],
            'answer': 'Yours sincerely',
          },
          {
            'question': 'Что означает "PS" в письме?',
            'options': [
              'После скриптум',
              'Главная идея',
              'Приветствие',
              'Подпись',
            ],
            'answer': 'После скриптум',
          },
          {
            'question': 'Как обратиться к женщине в формальном письме?',
            'options': ['Mr', 'Mrs/Ms', 'Mx', 'Sir'],
            'answer': 'Mrs/Ms',
          },
          {
            'question': 'Что означает "I am writing to..."',
            'options': [
              'Я читаю...',
              'Я пишу чтобы...',
              'Я говорю...',
              'Я думаю...',
            ],
            'answer': 'Я пишу чтобы...',
          },
          {
            'question': 'Как попросить о помощи в письме?',
            'options': [
              'Help me',
              'Could you please help me?',
              'You must help',
              'I need help',
            ],
            'answer': 'Could you please help me?',
          },
          {
            'question': 'Что означает "Looking forward to your reply"?',
            'options': [
              'Забудьте о письме',
              'Не отвечайте',
              'Жду вашего ответа',
              'Ответьте быстро',
            ],
            'answer': 'Жду вашего ответа',
          },
          {
            'question': 'Как извиниться за опоздание с ответом?',
            'options': [
              'Sorry I\'m late',
              'Sorry for the delay',
              'Sorry for waiting',
              'Sorry for writing',
            ],
            'answer': 'Sorry for the delay',
          },
          {
            'question': 'Что означает "Best regards"?',
            'options': [
              'С уважением',
              'С любовью',
              'До свидания',
              'Всего хорошего',
            ],
            'answer': 'С уважением',
          },
          {
            'question': 'Как выразить благодарность в письме?',
            'options': [
              'Thank you for...',
              'Sorry for...',
              'Please...',
              'Hello...',
            ],
            'answer': 'Thank you for...',
          },
          {
            'question': 'Что означает "Enclosed please find..."?',
            'options': [
              'Потеряно...',
              'Найдено...',
              'Прилагается...',
              'Отправлено...',
            ],
            'answer': 'Прилагается...',
          },
          {
            'question': 'Как вежливо отказаться в письме?',
            'options': [
              'No',
              'I refuse',
              'I\'m afraid I can\'t',
              'Not possible',
            ],
            'answer': 'I\'m afraid I can\'t',
          },
          {
            'question': 'Как начать письмо деловому партнеру?',
            'options': ['Hi there', 'Dear Mr. Smith', 'Hello boss', 'Hey'],
            'answer': 'Dear Mr. Smith',
          },
          {
            'question': 'Как закончить неформальное письмо?',
            'options': [
              'Yours sincerely',
              'Best wishes',
              'Yours truly',
              'Lots of love',
            ],
            'answer': 'Lots of love',
          },
          {
            'question': 'Что означает "CC" в письме?',
            'options': ['Скрытая копия', 'Копия', 'Приложение', 'Подпись'],
            'answer': 'Копия',
          },
          {
            'question': 'Как написать адрес в письме?',
            'options': [
              'В теме',
              'В начале письма',
              'В конце письма',
              'На конверте',
            ],
            'answer': 'На конверте',
          },
          {
            'question': 'Что означает "FYI" в письме?',
            'options': ['Для вашего сведения', 'Спешно', 'Секретно', 'Важно'],
            'answer': 'Для вашего сведения',
          },
          {
            'question': 'Как вежливо запросить информацию?',
            'options': [
              'Give me info',
              'Could you provide me with information',
              'I need info',
              'Tell me',
            ],
            'answer': 'Could you provide me with information',
          },
          {
            'question': 'Как выразить извинение в письме?',
            'options': [
              'I am angry',
              'I apologize',
              'I am sorry',
              'Sorry for inconvenience',
            ],
            'answer': 'I apologize',
          },
          {
            'question': 'Что означает "Yours faithfully"?',
            'options': ['С верой', 'С честью', 'С уважением', 'С любовью'],
            'answer': 'С уважением',
          },
          {
            'question': 'Как написать дату в письме?',
            'options': [
              '12.04.2026',
              'April 12, 2026',
              '2026-04-12',
              'Все варианты правильны',
            ],
            'answer': 'April 12, 2026',
          },
          {
            'question': 'Как переписать адрес получателя?',
            'options': [
              'На конверте',
              'В письме',
              'На открытке',
              'На странице',
            ],
            'answer': 'На конверте',
          },
          {
            'question': 'Как вежливо просить ответ?',
            'options': [
              'Answer me!',
              'Please reply soon',
              'Answer quickly',
              'I wait',
            ],
            'answer': 'Please reply soon',
          },
        ];

      case 'Урок 7: Чтение':
        return [
          {
            'question': 'Что означает слово "Chapter"?',
            'options': ['Книга', 'Страница', 'Глава', 'Содержание'],
            'answer': 'Глава',
          },
          {
            'question': 'Как переводится "Paragraph"?',
            'options': ['Предложение', 'Абзац', 'Заголовок', 'Слово'],
            'answer': 'Абзац',
          },
          {
            'question': 'Что означает "Read aloud"?',
            'options': [
              'Читать про себя',
              'Читать вслух',
              'Быстро читать',
              'Медленно читать',
            ],
            'answer': 'Читать вслух',
          },
          {
            'question': 'Как переводится "Context"?',
            'options': ['Слово', 'Предложение', 'Контекст', 'Текст'],
            'answer': 'Контекст',
          },
          {
            'question': 'Что означает "Main idea"?',
            'options': [
              'Второстепенная идея',
              'Главная мысль',
              'Деталь',
              'Заголовок',
            ],
            'answer': 'Главная мысль',
          },
          {
            'question': 'Как переводится "Comprehension"?',
            'options': ['Чтение', 'Письмо', 'Понимание', 'Говорение'],
            'answer': 'Понимание',
          },
          {
            'question': 'Что означает "Skim the text"?',
            'options': [
              'Внимательно читать',
              'Просмотреть по диагонали',
              'Переписать',
              'Выучить наизусть',
            ],
            'answer': 'Просмотреть по диагонали',
          },
          {
            'question': 'Как переводится "Vocabulary"?',
            'options': [
              'Грамматика',
              'Произношение',
              'Словарный запас',
              'Пунктуация',
            ],
            'answer': 'Словарный запас',
          },
          {
            'question': 'Что означает "Guess the meaning from context"?',
            'options': [
              'Посмотреть в словаре',
              'Догадаться из контекста',
              'Спросить у учителя',
              'Пропустить слово',
            ],
            'answer': 'Догадаться из контекста',
          },
          {
            'question': 'Как переводится "Fiction"?',
            'options': [
              'Научная литература',
              'Художественная литература',
              'Газета',
              'Журнал',
            ],
            'answer': 'Художественная литература',
          },
          {
            'question': 'Что означает "Scan for details"?',
            'options': [
              'Игнорировать детали',
              'Искать конкретную информацию',
              'Читать всё подряд',
              'Пропустить текст',
            ],
            'answer': 'Искать конкретную информацию',
          },
          {
            'question': 'Как переводится "Title"?',
            'options': ['Заголовок', 'Автор', 'Год', 'Издательство'],
            'answer': 'Заголовок',
          },
          {
            'question': 'Что означает "Non-fiction"?',
            'options': [
              'Художественная литература',
              'Научная литература',
              'Романы',
              'Сказки',
            ],
            'answer': 'Научная литература',
          },
          {
            'question': 'Как переводится "Preface"?',
            'options': [
              'Содержание',
              'Предисловие',
              'Заключение',
              'Приложение',
            ],
            'answer': 'Предисловие',
          },
          {
            'question': 'Что означает "Appendix"?',
            'options': ['Содержание', 'Предисловие', 'Приложение', 'Экскурс'],
            'answer': 'Приложение',
          },
          {
            'question': 'Как переводится "Introduction"?',
            'options': ['Содержание', 'Введение', 'Заключение', 'Предисловие'],
            'answer': 'Введение',
          },
          {
            'question': 'Что означает "Plot"?',
            'options': ['Герой', 'Сюжет', 'Место действия', 'Время'],
            'answer': 'Сюжет',
          },
          {
            'question': 'Как переводится "Author"?',
            'options': ['Издатель', 'Автор', 'Редактор', 'Печатник'],
            'answer': 'Автор',
          },
          {
            'question': 'Что означает "Character"?',
            'options': ['Герой', 'Характер', 'Персонаж', 'Все вышедши'],
            'answer': 'Персонаж',
          },
          {
            'question': 'Как переводится "Setting"?',
            'options': [
              'Сюжет',
              'Место и время действия',
              'Конфликт',
              'Развязка',
            ],
            'answer': 'Место и время действия',
          },
          {
            'question': 'Что означает "Summary"?',
            'options': ['Мораль', 'Резюме', 'Конспект', 'Краткое изложение'],
            'answer': 'Краткое изложение',
          },
          {
            'question': 'Как переводится "Theme"?',
            'options': ['Тема', 'Идея', 'Сюжет', 'Действие'],
            'answer': 'Тема',
          },
          {
            'question': 'Что означает "Tone"?',
            'options': ['Громкость', 'Тон автора', 'Музыка', 'Стиль'],
            'answer': 'Тон автора',
          },
          {
            'question': 'Как переводится "Narration"?',
            'options': ['Описание', 'Повествование', 'Диалог', 'Монолог'],
            'answer': 'Повествование',
          },
        ];

      case 'Урок 8: Культура и традиции':
        return [
          {
            'question': 'Что подают на Afternoon Tea в Британии?',
            'options': ['Пиццу', 'Суши', 'Сэндвичи и сконы', 'Бургеры'],
            'answer': 'Сэндвичи и сконы',
          },
          {
            'question': 'Когда празднуют Thanksgiving в США?',
            'options': [
              '25 декабря',
              '4 ноября',
              '4-й четверг ноября',
              '1 января',
            ],
            'answer': '4-й четверг ноября',
          },
          {
            'question': 'Что делают на Halloween?',
            'options': [
              'Дарят подарки',
              'Trick-or-treat',
              'Запускают фейерверки',
              'Ходят в церковь',
            ],
            'answer': 'Trick-or-treat',
          },
          {
            'question': 'Что символизирует 4th of July?',
            'options': [
              'День благодарения',
              'День независимости США',
              'День Святого Патрика',
              'Рождество',
            ],
            'answer': 'День независимости США',
          },
          {
            'question': 'Как называется австралийское приветствие?',
            'options': ['Hello', 'Hi', 'G\'day', 'Hey'],
            'answer': 'G\'day',
          },
          {
            'question': 'Что едят на Рождество в Австралии?',
            'options': ['Утку', 'Барбекю', 'Оливье', 'Пельмени'],
            'answer': 'Барбекю',
          },
          {
            'question': 'Какой цвет носят на St. Patrick\'s Day?',
            'options': ['Красный', 'Белый', 'Зеленый', 'Синий'],
            'answer': 'Зеленый',
          },
          {
            'question': 'Что такое "Boxing Day"?',
            'options': [
              'Боксерский день',
              'День подарков и распродаж',
              'День спорта',
              'День коробок',
            ],
            'answer': 'День подарков и распродаж',
          },
          {
            'question': 'Какой спорт главный в Канаде?',
            'options': ['Футбол', 'Бейсбол', 'Хоккей', 'Баскетбол'],
            'answer': 'Хоккей',
          },
          {
            'question': 'Что австралийцы называют "Barbie"?',
            'options': ['Куклу', 'Барбекю', 'Пляж', 'Машину'],
            'answer': 'Барбекю',
          },
          {
            'question': 'Когда празднуют Canada Day?',
            'options': ['1 июля', '4 июля', '1 января', '25 декабря'],
            'answer': '1 июля',
          },
          {
            'question': 'Что канадцы часто говорят в конце фразы?',
            'options': ['OK', 'Eh?', 'Yeah', 'Right'],
            'answer': 'Eh?',
          },
          {
            'question': 'Какой праздник отмечают 14 февраля?',
            'options': [
              'День святого Патрика',
              'День Святого Валентина',
              'День матери',
              'День отца',
            ],
            'answer': 'День Святого Валентина',
          },
          {
            'question': 'Что съедают в День благодарения?',
            'options': ['Рыбу', 'Индейку', 'Свинину', 'Говядину'],
            'answer': 'Индейку',
          },
          {
            'question': 'В какой стране отмечают день килта?',
            'options': ['Ирландия', 'Шотландия', 'Уэльс', 'Англия'],
            'answer': 'Шотландия',
          },
          {
            'question': 'Что означает "Boxing Day"?',
            'options': [
              'День подарков',
              'День бокса',
              'День коробок',
              'День спорта',
            ],
            'answer': 'День подарков',
          },
          {
            'question': 'Когда отмечают Рождество в англоязычных странах?',
            'options': ['25 декабря', '31 декабря', '1 января', '6 января'],
            'answer': '25 декабря',
          },
          {
            'question': 'Что такое "Hogmanay"?',
            'options': [
              'Шотландский Новый год',
              'Английский праздник',
              'Американский праздник',
              'Австралийский праздник',
            ],
            'answer': 'Шотландский Новый год',
          },
          {
            'question':
                'Какой традиционный напиток пьют на Новый год в Шотландии?',
            'options': ['Вино', 'Пиво', 'Виски', 'Коньяк'],
            'answer': 'Виски',
          },
          {
            'question': 'Что означает "Guy Fawkes Night"?',
            'options': [
              'День пожарного',
              'День фейерверков',
              'День гея',
              'День ночи',
            ],
            'answer': 'День фейерверков',
          },
          {
            'question': 'Памяти кого отмечают "Bonfire Night"?',
            'options': ['Короля', 'Потерпевшего', 'Героя', 'Гая Фокса'],
            'answer': 'Гая Фокса',
          },
          {
            'question': 'Какой спорт самый популярный в США?',
            'options': ['Футбол', 'Американский футбол', 'Бейсбол', 'Хоккей'],
            'answer': 'Американский футбол',
          },
          {
            'question': 'Что такое "Prom"?',
            'options': ['Промоция', 'Выпускной вечер', 'Прогулка', 'Парад'],
            'answer': 'Выпускной вечер',
          },
        ];

      default:
        return [
          {
            'question': 'Тестовый вопрос для урока: $title',
            'options': ['Вариант 1', 'Вариант 2', 'Вариант 3', 'Вариант 4'],
            'answer': 'Вариант 1',
          },
        ];
    }
  }

  List<Color> _getGradientColors(String title) {
    if (title.contains('Основы')) {
      return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    } else if (title.contains('Грамматика')) {
      return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
    } else if (title.contains('Словарь')) {
      return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
    } else if (title.contains('Разговорная практика')) {
      return [const Color(0xFF10B981), const Color(0xFF34D399)];
    } else if (title.contains('Аудирование')) {
      return [const Color(0xFFF59E0B), const Color(0xFFEF4444)];
    } else if (title.contains('Письмо')) {
      return [const Color(0xFF8B5CF6), const Color(0xFFD946EF)];
    } else if (title.contains('Чтение')) {
      return [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)];
    } else if (title.contains('Культура')) {
      return [const Color(0xFFF97316), const Color(0xFFFBBF24)];
    }
    return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
  }

  IconData _getLessonIcon(String title) {
    if (title.contains('Основы')) {
      return Icons.auto_stories_rounded;
    } else if (title.contains('Грамматика')) {
      return Icons.abc_rounded;
    } else if (title.contains('Словарь')) {
      return Icons.menu_book_rounded;
    } else if (title.contains('Разговорная')) {
      return Icons.record_voice_over_rounded;
    } else if (title.contains('Аудирование')) {
      return Icons.headphones_rounded;
    } else if (title.contains('Письмо')) {
      return Icons.edit_note_rounded;
    } else if (title.contains('Чтение')) {
      return Icons.library_books_rounded;
    } else if (title.contains('Культура')) {
      return Icons.public_rounded;
    }
    return Icons.school_rounded;
  }
}