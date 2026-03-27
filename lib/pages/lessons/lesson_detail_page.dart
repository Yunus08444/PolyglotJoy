import 'package:flutter/material.dart';

class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lesson = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final content = _getLessonContent(lesson['title']!);

    return Scaffold(
      appBar: AppBar(title: Text(lesson['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson['title']!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                lesson['subtitle']!,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Text(
                content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLessonContent(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return '''
Основы английского языка включают:

1. Алфавит (A-Z)
2. Фонетика и произношение
3. Основные приветствия:
   - Hello (Привет)
   - Hi (Привет)
   - Good morning (Доброе утро)
   - Good evening (Добрый вечер)

4. Числа от 1 до 10:
   - One, Two, Three, Four, Five
   - Six, Seven, Eight, Nine, Ten

Практика: Попробуйте поздороваться с кем-нибудь на английском!
        ''';
      case 'Урок 2: Грамматика':
        return '''
Основы грамматики:

1. Местоимения:
   - I (я)
   - You (ты/вы)
   - He/She/It (он/она/оно)
   - We (мы)
   - They (они)

2. Глагол "to be" (быть):
   - I am
   - You are
   - He/She/It is
   - We are
   - They are

3. Вопросительные слова:
   - What (что)
   - Where (где)
   - When (когда)
   - Why (почему)

Пример предложения: "I am a student." (Я студент.)
        ''';
      case 'Урок 3: Словарь':
        return '''
Базовый словарь:

Приветствия:
- Hello - Привет
- Goodbye - До свидания
- Thank you - Спасибо
- Please - Пожалуйста

Цвета:
- Red - Красный
- Blue - Синий
- Green - Зеленый
- Yellow - Желтый

Еда:
- Apple - Яблоко
- Bread - Хлеб
- Water - Вода
- Milk - Молоко

Практика: Выучите 5 новых слов сегодня!
        ''';
      case 'Урок 4: Разговорная практика':
        return '''
Разговорные фразы:

1. Знакомство:
   - What's your name? (Как тебя зовут?)
   - My name is... (Меня зовут...)
   - Nice to meet you. (Приятно познакомиться.)

2. Вопросы о здоровье:
   - How are you? (Как дела?)
   - I'm fine, thank you. (Хорошо, спасибо.)
   - And you? (А у тебя?)

3. В ресторане:
   - Can I have the menu? (Можно меню?)
   - I'd like... (Я бы хотел...)
   - The bill, please. (Счет, пожалуйста.)

Практика: Разыграйте диалог с другом!
        ''';
      default:
        return 'Содержимое урока скоро будет добавлено.';
    }
  }
}
