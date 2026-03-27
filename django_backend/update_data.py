import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from django.contrib.auth.models import User
from users.models import LanguageTest, Question

def update_sample_data():
    # Получить тестового пользователя
    user = User.objects.filter(username='testuser').first()
    if not user:
        print("❌ Тестовый пользователь не найден")
        return

    # Удалить тест "Русский алфавит"
    russian_test = LanguageTest.objects.filter(title='Русский алфавит').first()
    if russian_test:
        russian_test.delete()
        print("✅ Удален тест 'Русский алфавит'")

    # Получить или создать тест для английского
    english_test = LanguageTest.objects.filter(title='Основы английского языка').first()
    if not english_test:
        english_test = LanguageTest.objects.create(
            title='Основы английского языка',
            description='Базовые слова и фразы английского языка',
            created_by=user
        )

    # Дополнительные вопросы для английского
    additional_questions = [
        {
            'text': 'Как сказать "Я люблю тебя" на английском?',
            'answers': ['I love you', 'I like you', 'I hate you', 'I miss you'],
            'correct_index': 0
        },
        {
            'text': 'Что означает "House"?',
            'answers': ['Дом', 'Машина', 'Собака', 'Книга'],
            'correct_index': 0
        },
        {
            'text': 'Как переводится "Good morning"?',
            'answers': ['Доброе утро', 'Добрый день', 'Добрый вечер', 'Спокойной ночи'],
            'correct_index': 0
        },
        {
            'text': 'Что значит "Book"?',
            'answers': ['Книга', 'Ручка', 'Бумага', 'Карандаш'],
            'correct_index': 0
        },
        {
            'text': 'Как сказать "Спасибо большое" на английском?',
            'answers': ['Thank you very much', 'You are welcome', 'Excuse me', 'I am sorry'],
            'correct_index': 0
        },
        {
            'text': 'Что означает "Car"?',
            'answers': ['Машина', 'Велосипед', 'Самолет', 'Поезд'],
            'correct_index': 0
        },
        {
            'text': 'Как переводится "How are you"?',
            'answers': ['Как дела?', 'Кто ты?', 'Где ты?', 'Что ты делаешь?'],
            'correct_index': 0
        },
        {
            'text': 'Что значит "Food"?',
            'answers': ['Еда', 'Вода', 'Молоко', 'Сок'],
            'correct_index': 0
        },
        {
            'text': 'Как сказать "До свидания" на английском?',
            'answers': ['Goodbye', 'Hello', 'See you later', 'Nice to meet you'],
            'correct_index': 0
        },
        {
            'text': 'Что означает "School"?',
            'answers': ['Школа', 'Дом', 'Работа', 'Магазин'],
            'correct_index': 0
        },
        {
            'text': 'Как переводится "I am fine"?',
            'answers': ['У меня все хорошо', 'Я болен', 'Я голоден', 'Я устал'],
            'correct_index': 0
        },
        {
            'text': 'Что значит "Friend"?',
            'answers': ['Друг', 'Враг', 'Семья', 'Коллега'],
            'correct_index': 0
        },
        {
            'text': 'Как сказать "Извините" на английском?',
            'answers': ['Excuse me', 'Thank you', 'Please', 'Sorry'],
            'correct_index': 3
        },
        {
            'text': 'Что означает "Music"?',
            'answers': ['Музыка', 'Фильм', 'Спорт', 'Игра'],
            'correct_index': 0
        },
        {
            'text': 'Как переводится "What is your name"?',
            'answers': ['Как тебя зовут?', 'Сколько тебе лет?', 'Где ты живешь?', 'Что ты делаешь?'],
            'correct_index': 0
        }
    ]

    for q_data in additional_questions:
        Question.objects.create(
            test=english_test,
            text=q_data['text'],
            answers=q_data['answers'],
            correct_index=q_data['correct_index']
        )

    # Обновить тест глаголов
    verbs_test = LanguageTest.objects.filter(title='Английские глаголы').first()
    if verbs_test:
        # Добавить больше вопросов к глаголам
        verbs_additional = [
            {
                'text': 'Как сказать "бежать" на английском?',
                'answers': ['Run', 'Walk', 'Jump', 'Swim'],
                'correct_index': 0
            },
            {
                'text': 'Что означает "to read"?',
                'answers': ['Читать', 'Писать', 'Слушать', 'Говорить'],
                'correct_index': 0
            },
            {
                'text': 'Как переводится "to sleep"?',
                'answers': ['Спать', 'Есть', 'Пить', 'Работать'],
                'correct_index': 0
            }
        ]
        for q_data in verbs_additional:
            Question.objects.create(
                test=verbs_test,
                text=q_data['text'],
                answers=q_data['answers'],
                correct_index=q_data['correct_index']
            )

    print("✅ Данные обновлены:")
    print(f"   Тесты: {LanguageTest.objects.count()}")
    print(f"   Вопросы: {Question.objects.count()}")

if __name__ == '__main__':
    update_sample_data()