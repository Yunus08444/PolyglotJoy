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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      context.read<TestProvider>().loadTests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тесты')),
      body: Consumer<TestProvider>(
        builder: (context, tests, _) {
          if (tests.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tests.error != null) {
            return Center(child: Text('Ошибка: ${tests.error}'));
          }
          if (tests.tests.isEmpty) {
            return const Center(child: Text('Нет доступных тестов'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tests.tests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final test = tests.tests[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1DB954),
                    child: const Icon(Icons.flag, color: Colors.white),
                  ),
                  title: Text(test.title),
                  subtitle: Text('${test.questionsCount} вопросов'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // TODO: передать testId в вопрос/результат
                    Navigator.pushNamed(
                      context,
                      '/question',
                      arguments: test.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
