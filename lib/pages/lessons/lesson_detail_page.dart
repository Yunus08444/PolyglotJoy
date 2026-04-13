import 'dart:math';

import 'package:flutter/material.dart';

import '../../services/api/auth_service.dart';

class LessonListPage extends StatefulWidget {
  const LessonListPage({super.key});

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> _lessons = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final lessons = await _authService.getLessons();
      if (!mounted) return;

      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 34, 93),
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
            SizedBox(height: 16),
            Text(
              'Загрузка уроков...',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadLessons,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    if (_lessons.isEmpty) {
      return const Center(
        child: Text(
          'Пока нет доступных уроков',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLessons,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _lessons.length,
        itemBuilder: (context, index) {
          final lesson = _lessons[index];
          final isCompleted = lesson['is_completed'] == true;
          final title = lesson['title']?.toString() ?? 'Урок';
          final subtitle = lesson['subtitle']?.toString() ?? '';
          final gradientColors = _getGradientColors(title);
          final icon = _getLessonIcon(title);

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
                borderRadius: BorderRadius.circular(24),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/lesson_detail',
                    arguments: lesson,
                  );

                  if (result == true && mounted) {
                    _loadLessons();
                  }
                },
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
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
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
}

class LessonDetailPage extends StatefulWidget {
  const LessonDetailPage({super.key});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  final AuthService _authService = AuthService();

  Map<String, dynamic>? _lesson;
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = true;
  bool _isCompleting = false;
  bool _initialized = false;
  String? _error;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  final List<int> _wrongIndexes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      _error = 'Урок не найден';
      _isLoading = false;
      return;
    }

    _lesson = Map<String, dynamic>.from(args);
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final lessonId = _lesson?['id'];
    if (lessonId is! int) {
      setState(() {
        _error = 'У урока нет идентификатора';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _currentIndex = 0;
      _correctAnswers = 0;
      _wrongIndexes.clear();
    });

    try {
      final exercises = await _authService.getLessonExercises(lessonId);
      final preparedExercises = exercises.map((exercise) {
        final options = List<String>.from(exercise['options'] as List? ?? []);
        options.shuffle(Random());
        return {...exercise, 'options': options};
      }).toList();

      if (!mounted) return;

      setState(() {
        _exercises = preparedExercises;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _completeLessonAndExit() async {
    final lessonId = _lesson?['id'];
    if (lessonId is! int) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isCompleting = true);

    try {
      await _authService.completeLesson(lessonId);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context, true);
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson;
    final title = lesson?['title']?.toString() ?? 'Урок';
    final subtitle = lesson?['subtitle']?.toString() ?? '';
    final description = lesson?['description']?.toString() ?? '';
    final gradientColors = _getGradientColors(title);
    final icon = _getLessonIcon(title);

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
                title,
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
                  DecoratedBox(
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
                        Container(
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
                          title,
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
                        if (subtitle.isNotEmpty) ...[
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
                              subtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
                child: _buildLessonBody(description),
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

  Widget _buildLessonBody(String description) {
    if (_isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 56,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadExercises,
            child: const Text('Попробовать снова'),
          ),
        ],
      );
    }

    if (_exercises.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty) ...[
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 20),
          ],
          const Text(
            'Для этого урока пока нет упражнений.',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
        ],
      );
    }

    if (_currentIndex >= _exercises.length) {
      return _buildResult();
    }

    final exercise = _exercises[_currentIndex];
    final options = List<String>.from(exercise['options'] as List? ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty) ...[
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
        ],
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Вопрос ${_currentIndex + 1}/${_exercises.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${(((_currentIndex + 1) / _exercises.length) * 100).round()}%',
              style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _exercises.length,
          backgroundColor: const Color(0xFFE5E7EB),
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(10),
          minHeight: 6,
        ),
        const SizedBox(height: 28),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            exercise['question']?.toString() ?? 'Вопрос недоступен',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 28),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () => _answerQuestion(option),
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
                        String.fromCharCode(65 + index),
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
                      option,
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
        }),
      ],
    );
  }

  Widget _buildResult() {
    final scorePercent = (_correctAnswers / _exercises.length * 100).round();
    final passed = scorePercent >= 70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: passed ? Colors.green.shade50 : Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            passed ? Icons.emoji_events_rounded : Icons.school_rounded,
            size: 64,
            color: passed ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          passed ? 'Отлично!' : 'Хорошая попытка!',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Правильных ответов: $_correctAnswers из ${_exercises.length}',
          style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: passed ? Colors.green.shade100 : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$scorePercent%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: passed ? Colors.green.shade800 : Colors.orange.shade800,
            ),
          ),
        ),
        if (_wrongIndexes.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Разбор ошибок',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._wrongIndexes.map((index) {
            final exercise = _exercises[index];
            return Container(
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
                    'Вопрос ${index + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise['question']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '✅ Правильный ответ: ${exercise['answer']}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: _isCompleting ? null : _completeLessonAndExit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
          child: _isCompleting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Вернуться к урокам',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ],
    );
  }

  void _answerQuestion(String selectedOption) {
    final exercise = _exercises[_currentIndex];
    final correctAnswer = exercise['answer']?.toString();

    setState(() {
      if (selectedOption == correctAnswer) {
        _correctAnswers++;
      } else {
        _wrongIndexes.add(_currentIndex);
      }
      _currentIndex++;
    });
  }
}

List<Color> _getGradientColors(String title) {
  if (title.contains('Основы')) {
    return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
  } else if (title.contains('Грамматика')) {
    return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
  } else if (title.contains('Словарь')) {
    return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
  } else if (title.contains('Разговорная')) {
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
