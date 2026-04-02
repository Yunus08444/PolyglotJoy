import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';

class TestsListPage extends StatefulWidget {
  const TestsListPage({super.key});

  @override
  State<TestsListPage> createState() => _TestsListPageState();
}

class _TestsListPageState extends State<TestsListPage> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    // ✅ ДОБАВИЛИ: безопасный вызов после build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loaded) {
        _loaded = true;
        context.read<TestProvider>().loadTests();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ❌ УБРАЛИ вызов loadTests отсюда (оставили метод, но без логики)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A2C3E),
        title: const Text(
          'Тесты',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2C3E),
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                // TODO: добавить поиск или фильтрацию
              },
              icon: const Icon(Icons.search_rounded),
              splashRadius: 20,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<TestProvider>(
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
                          'Загрузка тестов...',
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
                            Icons.error_outline_rounded,
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
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (tests.error != null &&
                                  tests.error!.contains('Не авторизован')) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              } else {
                                context.read<TestProvider>().loadTests();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2EC4B6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              tests.error != null &&
                                      tests.error!.contains('Не авторизован')
                                  ? 'Войти'
                                  : 'Повторить',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (tests.tests.isEmpty) {
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
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(46, 196, 182, 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.quiz_rounded,
                              size: 50,
                              color: Color(0xFF2EC4B6),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Нет доступных тестов',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A2C3E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Попробуйте обновить список позже',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C7A8E),
                            ),
                          ),
                        ],
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
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: tests.tests.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final test = tests.tests[index];
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/question',
                                arguments: test.id,
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF2EC4B6),
                                          const Color(0xFF20A090),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF2EC4B6,
                                          ).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.quiz_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          test.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1A2C3E),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                  46,
                                                  196,
                                                  182,
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.help_outline_rounded,
                                                    size: 12,
                                                    color: Color(0xFF2EC4B6),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${test.questionsCount} вопросов',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF2EC4B6),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Consumer<TestProvider>(
              builder: (context, tests, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'count: ${context.read<TestProvider>().tests.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'loading: ${context.read<TestProvider>().isLoading}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'error: ${context.read<TestProvider>().error ?? "null"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
