import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            const Text(
              'Анна Иванова',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Пользователь', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const ListTile(
                leading: Icon(Icons.bar_chart, color: Color(0xFF1DB954)),
                title: Text('Прогресс'),
                subtitle: Text('4/5 тестов завершено'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const ListTile(
                leading: Icon(Icons.language, color: Color(0xFF1DB954)),
                title: Text('Текущий язык'),
                subtitle: Text('Английский'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
