import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from users.models import Lesson

lessons_data = [
    {'title': 'Урок 1: Основы', 'subtitle': 'Алфавит и приветствия', 'order': 1},
    {'title': 'Урок 2: Грамматика', 'subtitle': 'Личные местоимения и to be', 'order': 2},
    {'title': 'Урок 3: Словарь', 'subtitle': 'Цвета, еда, семья', 'order': 3},
    {'title': 'Урок 4: Разговорная практика', 'subtitle': 'Диалоги и фразы', 'order': 4},
    {'title': 'Урок 5: Аудирование', 'subtitle': 'Слушаем и повторяем', 'order': 5},
    {'title': 'Урок 6: Письмо', 'subtitle': 'Сообщения и письма', 'order': 6},
    {'title': 'Урок 7: Чтение', 'subtitle': 'Книги и тексты', 'order': 7},
    {'title': 'Урок 8: Культура и традиции', 'subtitle': 'Особенности страны', 'order': 8},
]

Lesson.objects.all().delete()

for lesson_data in lessons_data:
    Lesson.objects.create(**lesson_data)
    print(f"✅ Created: {lesson_data['title']}")

print(f"\n✅ Total lessons created: {Lesson.objects.count()}")
