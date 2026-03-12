import 'package:flutter/material.dart';

class TestsListPage extends StatelessWidget {
  const TestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тесты')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1DB954),
                child: const Icon(Icons.flag, color: Colors.white),
              ),
              title: Text('Тест ${index + 1}'),
              subtitle: const Text('Проходится за 10 минут, 15 вопросов'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => Navigator.pushNamed(context, '/question'),
            ),
          );
        },
      ),
    );
  }
}
