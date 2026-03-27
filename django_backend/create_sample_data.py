import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from django.contrib.auth.models import User
from users.models import LanguageTest, Question

def create_sample_data():
    # Получить или создать тестового пользователя
    user, created = User.objects.get_or_create(
        username='testuser',
        defaults={
            'email': 'test@example.com',
            'first_name': 'Test',
            'last_name': 'User'
        }
    )
    if created:
        user.set_password('TestPassword123')
        user.save()
        print("✅ Создан тестовый пользователь")

    # Создать тесты для английского языка
    english_test = LanguageTest.objects.create(
        title='Основы английского языка',
        description='Базовые слова и фразы',
        created_by=user
    )

    # Вопросы для английского
    questions_data = [
        {
            'text': 'Как переводится "Hello"?',
            'answers': ['Привет', 'Пока', 'Спасибо', 'Извините'],
            'correct_index': 0
        },
        {
            'text': 'Как сказать "Спасибо" на английском?',
            'answers': ['Thank you', 'Please', 'Excuse me', 'Goodbye'],
            'correct_index': 0
        },
        {
            'text': 'Что означает "Apple"?',
            'answers': ['Яблоко', 'Груша', 'Апельсин', 'Банан'],
            'correct_index': 0
        },
        {
            'text': 'Как переводится "Goodbye"?',
            'answers': ['До свидания', 'Привет', 'Спасибо', 'Пожалуйста'],
            'correct_index': 0
        },
        {
            'text': 'Что значит "Water"?',
            'answers': ['Вода', 'Огонь', 'Земля', 'Воздух'],
            'correct_index': 0
        },
        {
            'text': 'Как сказать "Пожалуйста" на английском?',
            'answers': ['Please', 'Thank you', 'Excuse me', 'Sorry'],
            'correct_index': 0
        },
        {
            'text': 'Что означает "Cat"?',
            'answers': ['Кот', 'Собака', 'Птица', 'Рыба'],
            'correct_index': 0
        }
    ]

    for q_data in questions_data:
        Question.objects.create(
            test=english_test,
            text=q_data['text'],
            answers=q_data['answers'],
            correct_index=q_data['correct_index']
        )

    # Создать тест для русского языка (для разнообразия)
    russian_test = LanguageTest.objects.create(
        title='Русский алфавит',
        description='Изучение букв русского алфавита',
        created_by=user
    )

    russian_questions = [
        {
            'text': 'Какая буква следует за "А"?',
            'answers': ['Б', 'В', 'Г', 'Д'],
            'correct_index': 0
        },
        {
            'text': 'Как называется эта буква: "Ж"?',
            'answers': ['Же', 'Зе', 'Ша', 'Ща'],
            'correct_index': 0
        },
        {
            'text': 'Какая буква перед "К"?',
            'answers': ['И', 'Й', 'К', 'Л'],
            'correct_index': 0
        }
    ]

    for q_data in russian_questions:
        Question.objects.create(
            test=russian_test,
            text=q_data['text'],
            answers=q_data['answers'],
            correct_index=q_data['correct_index']
        )

    # Создать еще один тест для английского
    english_test2 = LanguageTest.objects.create(
        title='Английские глаголы',
        description='Основные глаголы в английском',
        created_by=user
    )

    verbs_questions = [
        {
            'text': 'Что означает "to be"?',
            'answers': ['Быть', 'Иметь', 'Делать', 'Идти'],
            'correct_index': 0
        },
        {
            'text': 'Как сказать "есть" (to eat) на английском?',
            'answers': ['Eat', 'Drink', 'Sleep', 'Run'],
            'correct_index': 0
        }
    ]

    for q_data in verbs_questions:
        Question.objects.create(
            test=english_test2,
            text=q_data['text'],
            answers=q_data['answers'],
            correct_index=q_data['correct_index']
        )

    print("✅ Созданы тестовые данные:")
    print(f"   Тесты: {LanguageTest.objects.count()}")
    print(f"   Вопросы: {Question.objects.count()}")

if __name__ == '__main__':
    create_sample_data()