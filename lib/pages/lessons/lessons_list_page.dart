import 'package:flutter/material.dart';

class LessonsListPage extends StatelessWidget {
  const LessonsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      {'title': 'Урок 1: Основы', 'subtitle': 'Вводные понятия и термины'},
      {
        'title': 'Урок 2: Грамматика',
        'subtitle': 'Согласование времени и падежи',
      },
      {'title': 'Урок 3: Словарь', 'subtitle': '100 ключевых слов'},
      {
        'title': 'Урок 4: Разговорная практика',
        'subtitle': 'Диалоги и выражения',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Уроки')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF4361EE),
                child: Icon(Icons.book, color: Colors.white),
              ),
              title: Text(lesson['title']!),
              subtitle: Text(lesson['subtitle']!),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/lesson_detail',
                  arguments: lesson,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
