import 'package:flutter/material.dart';

class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lesson = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final content = _getLessonContent(lesson['title']!);
    final gradientColors = _getGradientColors(lesson['title']!);
    final icon = _getLessonIcon(lesson['title']!);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Современный SliverAppBar с параллакс-эффектом
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2C3E50)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lesson['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
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
                  // Градиентный фон
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                    ),
                  ),
                  // Декоративные круги
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  // Контент в шапке
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          lesson['title']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            lesson['subtitle']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Основной контент
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
              child: Column(
                children: [
                  // Декоративная полоска сверху
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок с иконкой
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(icon, size: 24, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Материалы урока',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Color(0xFFE8ECF0)),
                        const SizedBox(height: 24),
                        // Контент
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF2D3436),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Декоративная подпись
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline, size: 20, color: gradientColors.first),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Отметьте этот урок как пройденный, когда освоите материал',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: gradientColors.first,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case 'Урок 2: Грамматика':
        return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
      case 'Урок 3: Словарь':
        return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
      case 'Урок 4: Разговорная практика':
        return [const Color(0xFF10B981), const Color(0xFF34D399)];
      case 'Урок 5: Аудирование':
        return [const Color(0xFFF59E0B), const Color(0xFFEF4444)];
      case 'Урок 6: Письмо':
        return [const Color(0xFF8B5CF6), const Color(0xFFD946EF)];
      case 'Урок 7: Чтение':
        return [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)];
      case 'Урок 8: Культура и традиции':
        return [const Color(0xFFF97316), const Color(0xFFFBBF24)];
      default:
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    }
  }

  IconData _getLessonIcon(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return Icons.auto_stories_rounded;
      case 'Урок 2: Грамматика':
        return Icons.abc_rounded;
      case 'Урок 3: Словарь':
        return Icons.menu_book_rounded;
      case 'Урок 4: Разговорная практика':
        return Icons.record_voice_over_rounded;
      case 'Урок 5: Аудирование':
        return Icons.headphones_rounded;
      case 'Урок 6: Письмо':
        return Icons.edit_note_rounded;
      case 'Урок 7: Чтение':
        return Icons.library_books_rounded;
      case 'Урок 8: Культура и традиции':
        return Icons.public_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _getLessonContent(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return '''
📚 **УРОК 1: ОСНОВЫ АНГЛИЙСКОГО ЯЗЫКА**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔤 **1. АЛФАВИТ (THE ALPHABET)**

Английский алфавит состоит из 26 букв:

**Гласные (Vowels):** A, E, I, O, U (и иногда Y)

**Согласные (Consonants):** B, C, D, F, G, H, J, K, L, M, N, P, Q, R, S, T, V, W, X, Y, Z

🎵 **Совет:** Спойте песенку "ABC" — это самый быстрый способ запомнить порядок букв!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🗣️ **2. ФОНЕТИКА И ПРОИЗНОШЕНИЕ**

**Самые важные звуки:**

• /θ/ (как в "think") — язык между зубами
• /ð/ (как в "this") — звонкая версия
• /r/ — не раскатистая, как в русском
• /æ/ (как в "cat") — широкий звук "э"
• /ə/ (schwa) — самый частый звук, как безударное "а"

💡 **Лайфхак:** Смотрите на движение рта носителей языка в YouTube-роликах!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👋 **3. ПРИВЕТСТВИЯ И ПРОЩАНИЯ**

**Неформальные (с друзьями):**
• Hi! — Привет!
• Hey! — Привет! (очень неформально)
• What's up? — Как дела? / Что нового?
• How's it going? — Как оно?

**Формальные (в работе/с незнакомыми):**
• Good morning! — Доброе утро! (до 12:00)
• Good afternoon! — Добрый день! (12:00-18:00)
• Good evening! — Добрый вечер! (после 18:00)
• It's nice to meet you — Приятно познакомиться

**Прощания:**
• Bye! / Goodbye!
• See you later! — Увидимся!
• Take care! — Береги себя!
• Have a nice day! — Хорошего дня!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔢 **4. ЧИСЛА ОТ 1 ДО 20**

**Базовые числа:**
1 - One    6 - Six     11 - Eleven   16 - Sixteen
2 - Two    7 - Seven   12 - Twelve   17 - Seventeen
3 - Three  8 - Eight   13 - Thirteen 18 - Eighteen
4 - Four   9 - Nine    14 - Fourteen 19 - Nineteen
5 - Five   10 - Ten    15 - Fifteen  20 - Twenty

**Десятки:**
10 - Ten    30 - Thirty    50 - Fifty
20 - Twenty 40 - Forty     60 - Sixty

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **5. ПРАКТИЧЕСКОЕ ЗАДАНИЕ**

1. Напишите свой номер телефона на английском
2. Поздоровайтесь с тремя людьми на английском сегодня
3. Запишите звук /θ/ и /ð/ (think vs this)

✨ **Помните:** 15 минут практики каждый день лучше, чем 2 часа раз в неделю!
        ''';
      case 'Урок 2: Грамматика':
        return '''
📖 **УРОК 2: ОСНОВЫ ГРАММАТИКИ**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 **1. ЛИЧНЫЕ МЕСТОИМЕНИЯ (PERSONAL PRONOUNS)**

| Лицо    | Единственное | Множественное |
|---------|-------------|---------------|
| 1-е     | I (я)       | We (мы)       |
| 2-е     | You (ты)    | You (вы)      |
| 3-е (м) | He (он)     | They (они)    |
| 3-е (ж) | She (она)   | They (они)    |
| 3-е (с) | It (оно)    | They (они)    |

**Важно:** В английском нет разделения на "ты" и "вы" — везде "You"!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡ **2. ГЛАГОЛ "TO BE" — САМЫЙ ВАЖНЫЙ ГЛАГОЛ**

**Спряжение в настоящем времени (Present Simple):**

| Местоимение | Форма | Пример                    | Перевод          |
|-------------|-------|---------------------------|------------------|
| I           | am    | I am a teacher           | Я учитель        |
| You         | are   | You are my friend        | Ты мой друг      |
| He          | is    | He is happy              | Он счастлив      |
| She         | is    | She is beautiful         | Она красивая     |
| It          | is    | It is cold               | Холодно          |
| We          | are   | We are ready             | Мы готовы        |
| They        | are   | They are students        | Они студенты     |

**Отрицательная форма:** добавляем "not"
• I am not → I'm not
• You are not → You aren't
• He is not → He isn't

**Вопросительная форма:** меняем местами
• Am I? Are you? Is he? Are we? Are they?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❓ **3. ВОПРОСИТЕЛЬНЫЕ СЛОВА (QUESTION WORDS)**

| Слово   | Значение      | Пример                           |
|---------|---------------|----------------------------------|
| What    | Что / Какой   | What is your name?               |
| Where   | Где / Куда    | Where do you live?               |
| When    | Когда         | When does the movie start?       |
| Why     | Почему        | Why are you late?                |
| Who     | Кто           | Who is that girl?                |
| Which   | Который / Какой| Which color do you prefer?       |
| How     | Как           | How are you?                     |
| How many| Сколько       | How many books do you have?      |
| How much| Сколько (цена)| How much is this?                |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 **4. ПОСТРОЕНИЕ ПРЕДЛОЖЕНИЙ**

**Порядок слов в утверждении:**
Subject + Verb + Object
(Подлежащее + Глагол + Дополнение)

**Примеры:**
• I + love + coffee. (Я люблю кофе)
• She + reads + books. (Она читает книги)
• They + play + football. (Они играют в футбол)

**В вопросах с глаголом "to be":**
Verb + Subject + Object?
(Глагол + Подлежащее + Дополнение?)

• Are you happy?
• Is she a doctor?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✏️ **5. УПРАЖНЕНИЯ**

**Задание 1:** Вставьте правильную форму "to be"
1. I ___ a student.
2. They ___ at home.
3. She ___ my sister.
4. We ___ happy.
5. It ___ a cat.

**Задание 2:** Составьте вопросы
1. your name / what / is → ?
2. live / where / you / do → ?
3. you / are / how → ?

**Ответы:**
Задание 1: 1-am, 2-are, 3-is, 4-are, 5-is
Задание 2: What is your name? Where do you live? How are you?
        ''';
      case 'Урок 3: Словарь':
        return '''
📝 **УРОК 3: РАСШИРЯЕМ СЛОВАРНЫЙ ЗАПАС**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👋 **1. ПРИВЕТСТВИЯ И ВЕЖЛИВОСТЬ**

| English              | Русский            | Примечание                    |
|----------------------|--------------------|-------------------------------|
| Hello                | Здравствуйте       | Универсальное                 |
| Hi                   | Привет             | Неформальное                  |
| Good morning         | Доброе утро        | До 12:00                      |
| Good afternoon       | Добрый день        | 12:00-18:00                   |
| Good evening         | Добрый вечер       | После 18:00                   |
| Good night           | Спокойной ночи     | Только перед сном             |
| Thank you            | Спасибо            | Можно "Thanks"                |
| You're welcome       | Пожалуйста (ответ) | На "Thank you"                |
| Please               | Пожалуйста (просьба)| Перед просьбой                |
| Sorry                | Извините / Простите |                               |
| Excuse me            | Извините (привлечь внимание)|                        |
| Yes / No             | Да / Нет           |                               |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎨 **2. ЦВЕТА (COLORS)**

| English   | Русский    | English   | Русский    |
|-----------|------------|-----------|------------|
| Red       | Красный    | Pink      | Розовый    |
| Blue      | Синий      | Brown     | Коричневый |
| Green     | Зеленый    | Purple    | Фиолетовый |
| Yellow    | Желтый     | Orange    | Оранжевый  |
| Black     | Черный     | Gray/Grey | Серый      |
| White     | Белый      | Gold      | Золотой    |
| Silver    | Серебряный |           |            |

🎨 **Идиомы с цветами:**
• "Feel blue" — грустить
• "Green with envy" — позеленеть от зависти
• "White lie" — ложь во спасение

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🍎 **3. ЕДА И НАПИТКИ (FOOD & DRINKS)**

**Фрукты и овощи:**
Apple (яблоко) - Banana (банан) - Orange (апельсин)
Tomato (помидор) - Potato (картофель) - Carrot (морковь)

**Основные продукты:**
Bread (хлеб) - Meat (мясо) - Chicken (курица)
Fish (рыба) - Rice (рис) - Pasta (паста)
Cheese (сыр) - Egg (яйцо) - Milk (молоко)

**Напитки:**
Water (вода) - Coffee (кофе) - Tea (чай)
Juice (сок) - Wine (вино) - Beer (пиво)

**Приемы пищи:**
Breakfast (завтрак) - Lunch (обед) - Dinner (ужин)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👨‍👩‍👧‍👦 **4. СЕМЬЯ (FAMILY)**

| English      | Русский      | English        | Русский        |
|--------------|--------------|----------------|----------------|
| Mother / Mom | Мама         | Father / Dad   | Папа           |
| Parents      | Родители     | Children       | Дети           |
| Son          | Сын          | Daughter       | Дочь           |
| Brother      | Брат         | Sister         | Сестра         |
| Grandmother  | Бабушка      | Grandfather    | Дедушка        |
| Uncle        | Дядя         | Aunt           | Тетя           |
| Cousin       | Двоюродный брат/сестра | Nephew   | Племянник      |
| Niece        | Племянница   | Husband        | Муж            |
| Wife         | Жена         |                |                |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏠 **5. ДОМ И ПОВСЕДНЕВНЫЕ ПРЕДМЕТЫ**

**Комнаты:**
Living room (гостиная) - Bedroom (спальня)
Kitchen (кухня) - Bathroom (ванная)

**Мебель:**
Table (стол) - Chair (стул) - Bed (кровать)
Sofa (диван) - Wardrobe (шкаф)

**Бытовая техника:**
TV (телевизор) - Fridge (холодильник)
Washing machine (стиральная машина)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **6. МЕТОДЫ ЗАПОМИНАНИЯ СЛОВ**

1. **Карточки (Flashcards)** — напишите слово на одной стороне, перевод на другой
2. **Ассоциации** — связывайте слово с картинкой или ситуацией
3. **Контекст** — учите слова в предложениях, а не изолированно
4. **Повторение** — используйте метод интервального повторения (через 1 час, 1 день, 1 неделю)

📱 **Приложения для словаря:** Anki, Quizlet, Memrise

💪 **Задание:** Выучите 10 новых слов из этого урока и составьте с ними 5 предложений!
        ''';
      case 'Урок 4: Разговорная практика':
        return '''
💬 **УРОК 4: РАЗГОВОРНАЯ ПРАКТИКА**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👋 **1. ЗНАКОМСТВО (INTRODUCTION)**

**Диалог 1: Новая встреча**

A: "Hi! I'm Sarah. What's your name?"
B: "Hello, Sarah. I'm Mike. Nice to meet you!"
A: "Nice to meet you too, Mike. Where are you from?"
B: "I'm from London. And you?"
A: "I'm from New York. Do you like it here?"
B: "Yes, it's great! So many new people."

**Полезные фразы:**
• What's your name? — Как тебя зовут?
• My name is... — Меня зовут...
• Nice to meet you — Приятно познакомиться
• Where are you from? — Откуда ты?
• I'm from... — Я из...
• How old are you? — Сколько тебе лет?
• What do you do? — Чем ты занимаешься?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

😊 **2. КАК ДЕЛА? (HOW ARE YOU?)**

**Вопросы о настроении:**
• How are you? — Как дела?
• How's it going? — Как оно?
• What's up? — Что нового?
• How have you been? — Как поживаешь? (давно не виделись)

**Ответы:**
**Позитивные:**
• I'm fine, thank you — Хорошо, спасибо
• Great! — Отлично!
• Pretty good — Довольно хорошо
• Can't complain — Не жалуюсь

**Нейтральные:**
• Not bad — Неплохо
• So-so — Так себе
• Same as always — Как всегда

**Негативные:**
• I'm tired — Я устал
• Not so good — Не очень хорошо
• I've been better — Бывало и лучше

**Диалог 2:**
A: "Hey! How are you doing?"
B: "I'm doing great, thanks! And you?"
A: "Pretty good, just a bit tired."
B: "Oh, you should get some rest!"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🍽️ **3. В РЕСТОРАНЕ / КАФЕ (AT THE RESTAURANT)**

**Диалог 3:**

**Официант (Waiter):** "Good evening! Welcome to our restaurant. Table for two?"
**Гость (Customer):** "Yes, please. By the window if possible."
**Официант:** "Of course. Here are your menus. Can I get you any drinks?"
**Гость:** "I'd like a glass of water, please."
**Официант:** "Are you ready to order?"
**Гость:** "What do you recommend?"
**Официант:** "The grilled salmon is very popular."
**Гость:** "Sounds good! I'll have that."
*(После еды - After the meal)*
**Гость:** "That was delicious! Can I have the bill, please?"
**Официант:** "Sure. Here you are."
**Гость:** "Keep the change."

**Полезные фразы:**
• Can I have the menu? — Можно меню?
• What do you recommend? — Что посоветуете?
• I'd like... — Я бы хотел...
• The bill, please — Счет, пожалуйста
• Is service included? — Обслуживание включено?
• I have a reservation — У меня бронь

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🛒 **4. В МАГАЗИНЕ (SHOPPING)**

**Диалог 4:**

**Продавец (Shop assistant):** "Can I help you?"
**Покупатель (Customer):** "Yes, I'm looking for a blue sweater."
**Продавец:** "What size do you need?"
**Покупатель:** "Medium, please. How much is this one?"
**Продавец:** "It's \$45. But there's a 20% discount today."
**Покупатель:** "Great! Can I try it on?"
**Продавец:** "The fitting room is over there."
*(После примерки)*
**Покупатель:** "It fits perfectly. I'll take it!"
**Продавец:** "Cash or card?"
**Покупатель:** "Card, please."

**Полезные фразы:**
• How much is this? — Сколько это стоит?
• Can I try it on? — Можно примерить?
• Do you have this in another size/color? — Есть другой размер/цвет?
• I'm just looking — Я просто смотрю
• I'll take it — Я беру
• It's too expensive — Слишком дорого

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏥 **5. У ВРАЧА (AT THE DOCTOR)**

**Диалог 5:**

**Врач (Doctor):** "What seems to be the problem?"
**Пациент (Patient):** "I have a headache and a sore throat."
**Врач:** "Do you have a fever?"
**Пациент:** "Yes, I think so. I feel very tired."
**Врач:** "Let me check your temperature. You have a slight fever."
**Пациент:** "What should I do?"
**Врач:** "Drink plenty of water and get some rest. Take this medicine twice a day."

**Симптомы (Symptoms):**
• headache — головная боль
• stomachache — боль в животе
• cough — кашель
• runny nose — насморк

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎭 **6. ПРАКТИЧЕСКОЕ ЗАДАНИЕ**

**Разминка:** Прочитайте каждый диалог вслух 3 раза
**Ролевая игра:** Найдите друга и разыграйте один из диалогов
**Запись:** Запишите свой голос и сравните с оригинальным произношением

🎯 **Совет:** Не бойтесь ошибок! Носители языка ценят смелость говорить больше, чем идеальную грамматику.
        ''';
      case 'Урок 5: Аудирование':
        return '''
🎧 **УРОК 5: АУДИРОВАНИЕ**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👂 **1. ПОЧЕМУ АУДИРОВАНИЕ — ЭТО ВАЖНО?**

В реальном общении мы:
• 45% времени — слушаем
• 30% — говорим
• 16% — читаем
• 9% — пишем

**Проблемы начинающих:**
❌ Носители говорят слишком быстро
❌ Незнакомые акценты
❌ Слова сливаются в одно целое
❌ Фоновый шум

**Что происходит в речи носителей:**

**Connected Speech (связная речь):**
• "What do you want?" → "Whaddaya want?"
• "Going to" → "Gonna"
• "Want to" → "Wanna"
• "Let me" → "Lemme"
• "Give me" → "Gimme"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **2. УРОВНИ АУДИРОВАНИЯ**

| Уровень  | Что понимаете                                    | Что делать                     |
|----------|--------------------------------------------------|--------------------------------|
| A1 (Beginner) | Отдельные слова и простые фразы            | Слушать медленную речь, детские песни |
| A2 (Elementary)| Простые предложения, если говорят медленно | Подкасты для learners          |
| B1 (Intermediate)| Основную идею, даже если есть незнакомые слова | Новости на медленном английском |
| B2 (Upper) | Детали, мнения, эмоции                          | Сериалы с субтитрами           |
| C1 (Advanced)| Почти всё, включая сленг и акценты              | Оригинальные фильмы, подкасты  |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📱 **3. РЕСУРСЫ ДЛЯ ТРЕНИРОВКИ**

**Приложения (Apps):**
• **Duolingo Podcast** — реальные истории на понятном английском
• **BBC Learning English** — бесплатные уроки с транскриптами
• **LingQ** — учит распознавать слова в потоке речи
• **ELSA Speak** — анализирует ваше произношение

**YouTube каналы:**
• **English with Lucy** — британский английский, четкая дикция
• **Rachel's English** — американский английский, разбор звуков
• **Learn English with TV Series** — учим английский по сериалам
• **Vox** — короткие видео на разные темы (с субтитрами)

**Подкасты (для начинающих):**
1. "6 Minute English" (BBC) — идеально для ежедневной практики
2. "English Learning for Curious Minds" — интересные темы
3. "ESL Pod" — медленный и понятный английский

**Подкасты (для среднего уровня):**
1. "Stuff You Should Know" — популярные темы
2. "TED Talks Daily" — вдохновляющие выступления
3. "The Daily" (NY Times) — новости дня

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎬 **4. КАК СМОТРЕТЬ СЕРИАЛЫ С ПОЛЬЗОЙ**

**Метод 3 этапов:**

**Этап 1 (С русскими субтитрами):**
• Смотрите для понимания сюжета
• Выписывайте 10 интересных фраз

**Этап 2 (С английскими субтитрами):**
• Останавливайте на сложных местах
• Повторяйте фразы за актерами
• Ищите незнакомые слова

**Этап 3 (Без субтитров):**
• Смотрите ту же серию снова
• Проверьте, сколько поняли
• Перескажите сюжет своими словами

**Какие сериалы подходят:**

**Для начинающих (A2-B1):**
• "Peppa Pig" — простой язык, четкое произношение
• "Extra English" — создан для изучающих
• "Friends" — классика, много повседневных фраз

**Для среднего уровня (B1-B2):**
• "The Office" — паузы между репликами
• "Modern Family" — разные акценты и возрасты
• "Stranger Things" — современный язык

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🗣️ **5. АКЦЕНТЫ И ДИАЛЕКТЫ**

**Британский vs Американский:**

| Британский           | Американский       |
|----------------------|--------------------|
| Water → "Wo-tah"    | Water → "Wa-der"   |
| Schedule → "Shed-yool"| Schedule → "Ske-jool"|
| Colour → "Cull-uh"  | Colour → "Cull-er" |

**Другие акценты:**
• Австралийский — "G'day mate!" (Hello friend)
• Канадский — похож на американский, но "out" звучит как "oot"
• Ирландский — мягкий, музыкальный

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎧 **6. ПРАКТИЧЕСКИЕ УПРАЖНЕНИЯ**

**Упражнение 1 (Transcription):**
Найдите 1-минутное аудио, напишите всё, что услышали. Проверьте с транскриптом.

**Упражнение 2 (Shadowing — "тень"):**
Включите аудио и повторяйте ЗА диктором с той же скоростью и интонацией.

**Упражнение 3 (Prediction):**
Остановите аудио и угадайте, что скажут дальше.

**Упражнение 4 (Summarizing):**
Прослушайте 2-минутное аудио и перескажите главное (30 секунд).

📅 **План на неделю:**
• ПН-СР: 15 минут подкаста
• ЧТ-ПТ: 15 минут сериала с субтитрами
• СБ: 15 минут без субтитров
• ВС: 15 минут shadowing

🎯 **Задание:** Найдите любой эпизод "6 Minute English" (BBC), прослушайте 3 раза и выпишите 5 новых фраз.
        ''';
      case 'Урок 6: Письмо':
        return '''
✍️ **УРОК 6: ПИСЬМО НА АНГЛИЙСКОМ**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📧 **1. НЕФОРМАЛЬНОЕ ПИСЬМО ДРУГУ (INFORMAL EMAIL)**

**Структура:**

1. **Subject (Тема)** — кратко о чем письмо
2. **Greeting (Приветствие)**
3. **Opening (Вступление)**
4. **Main body (Основная часть)**
5. **Closing (Заключение)**
6. **Signature (Подпись)**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Пример письма другу:**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Фразы для неформального письма:**

**Приветствия:**
• Dear [Name],
• Hi [Name],
• Hey [Name],

**Открывающие фразы:**
• How are you? / How's it going?
• I hope you're doing well.
• Long time no see!
• It's been a while since we last talked.
• I'm writing to tell you about...

**Основная часть:**
• Guess what? — Угадай что?
• You won't believe it but... — Ты не поверишь, но...
• By the way — Кстати
• Actually — Вообще-то
• To be honest — Честно говоря

**Заключение:**
• Anyway, I should get going. — Ладно, мне пора.
• Write back soon! — Ответь скорее!
• Looking forward to hearing from you. — Жду ответа.
• Take care of yourself. — Береги себя.

**Подписи:**
• Love, (очень близким)
• Best wishes,
• Yours,
• Take care,
• Cheers, (неформально)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💼 **2. ФОРМАЛЬНОЕ ПИСЬМО (FORMAL EMAIL)**

**Пример: Запрос информации**

**Фразы для формальных писем:**

**Приветствия:**
• Dear Sir or Madam, (если не знаете имя)
• Dear Mr. Smith, (если знаете)
• To whom it may concern, (очень формально)

**Открывающие фразы:**
• I am writing to... — Я пишу, чтобы...
• I would like to inquire about... — Я хотел бы узнать о...
• Thank you for your prompt response. — Спасибо за быстрый ответ.
• Further to our conversation... — В продолжение нашего разговора...

**Заключение:**
• Thank you for your consideration. — Спасибо за внимание.
• I look forward to hearing from you. — Жду ответа.
• Please do not hesitate to contact me. — Не стесняйтесь обращаться.

**Подписи:**
• Yours sincerely, (если знаете имя)
• Yours faithfully, (если не знаете имя)
• Best regards,
• Sincerely,

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📱 **3. СООБЩЕНИЯ В МЕССЕНДЖЕРАХ**

**Особенности:**
• Коротко и по делу
• Много сокращений
• Эмодзи и гифки

**Популярные сокращения:**
| Сокращение | Полная форма | Перевод |
|------------|--------------|---------|
| LOL | Laughing Out Loud | громко смеюсь |
| BRB | Be Right Back | скоро вернусь |
| IDK | I Don't Know | не знаю |
| TTYL | Talk To You Later | поговорим позже |
| BTW | By The Way | кстати |
| OMG | Oh My God | о боже |
| ASAP | As Soon As Possible | как можно скорее |
| FYI | For Your Information | к вашему сведению |

**Пример чата:**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✏️ **4. ГРАММАТИКА ДЛЯ ПИСЬМА**

**Советы:**
• Используйте короткие предложения
• Не забывайте про заглавные буквы и точки
• Проверяйте времена глаголов
• Избегайте повторов

**Связующие слова (Connectors):**

| Слово | Значение | Пример |
|-------|----------|--------|
| However | Однако | I like coffee. However, I don't drink it at night. |
| Therefore | Поэтому | I was tired. Therefore, I went to bed early. |
| Moreover | Более того | The food was delicious. Moreover, it was cheap. |
| Firstly / Secondly | Во-первых / Во-вторых | Firstly, it's healthy. Secondly, it's tasty. |
| In conclusion | В заключение | In conclusion, learning English is useful. |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 **5. ТИПИЧНЫЕ ОШИБКИ**

❌ **Неправильно:** I am write a letter.
✅ **Правильно:** I am writing a letter.

❌ **Неправильно:** He go to school.
✅ **Правильно:** He goes to school.

❌ **Неправильно:** I have 20 years.
✅ **Правильно:** I am 20 years old.

❌ **Неправильно:** My name is...
✅ **Правильно:** My name is...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **6. ПРАКТИЧЕСКИЕ ЗАДАНИЯ**

**Задание 1:** Напишите email другу о том, как прошел ваш день (100 слов)

**Задание 2:** Напишите формальное письмо с вопросом о работе или учебе (80 слов)

**Задание 3:** Напишите 3 сообщения в мессенджере, используя 5 разных сокращений

**Задание 4:** Исправьте ошибки в этом тексте:
"hi my name is john i from usa i am 25 years old i like play football"

✨ **Совет:** Используйте Grammarly или LanguageTool для проверки своих писем!
        ''';
      case 'Урок 7: Чтение':
        return '''
📖 **УРОК 7: ЧТЕНИЕ НА АНГЛИЙСКОМ**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 **1. ПОЧЕМУ ЧТЕНИЕ РАЗВИВАЕТ ЯЗЫК?**

**Преимущества чтения:**
✅ Расширяет словарный запас (до 1000 слов в год при ежедневном чтении)
✅ Улучшает грамматику без зубрежки
✅ Знакомит с живыми фразами и идиомами
✅ Развивает скорость мышления на английском
✅ Повышает общую эрудицию

**Сколько нужно читать?**
• Начинающим: 10-15 минут в день
• Средний уровень: 20-30 минут
• Продвинутый: 30-60 минут

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📖 **2. КНИГИ ПО УРОВНЯМ**

**Уровень A1-A2 (Beginner - Elementary):**
Идеально: детские книги, комиксы, адаптированные издания

1. **"The Little Prince"** — Antoine de Saint-Exupéry
   • Объем: ~20 000 слов
   • Простые предложения, философские темы

2. **"Charlotte's Web"** — E.B. White
   • Классика для детей
   • Много повторов, легко запоминать

3. **"Diary of a Wimpy Kid"** — Jeff Kinney
   • Современный язык, много картинок
   • Разговорные фразы из реальной жизни

4. **Oxford Bookworms Library** (серия)
   • Специально для изучающих
   • Есть задания и словарь

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Уровень B1-B2 (Intermediate - Upper Intermediate):**

1. **"Harry Potter and the Sorcerer's Stone"** — J.K. Rowling
   • Объем: ~77 000 слов
   • Язык становится сложнее от книги к книге
   • Много диалогов

2. **"The Giver"** — Lois Lowry
   • Простой, но глубокий язык
   • Интересный сюжет, легко увлечься

3. **"Animal Farm"** — George Orwell
   • Короткая (всего ~30 000 слов)
   • Важная аллегория, много исторических отсылок

4. **"The Curious Incident of the Dog in the Night-Time"** — Mark Haddon
   • Необычный повествователь
   • Ясный, логичный язык

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Уровень C1-C2 (Advanced):**

1. **"1984"** — George Orwell
2. **"To Kill a Mockingbird"** — Harper Lee
3. **"Pride and Prejudice"** — Jane Austen
4. **"The Great Gatsby"** — F. Scott Fitzgerald

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📰 **3. НОВОСТИ И СТАТЬИ**

**Где читать новости на понятном английском:**

• **News in Levels** — новости на 3 уровнях сложности
• **Breaking News English** — адаптированные новости с заданиями
• **BBC News** — британский вариант, четкая речь
• **CNN** — американские новости
• **The Guardian** — качественные статьи на разные темы

**Как читать новости:**
1. Прочитайте заголовок — о чем текст?
2. Прочитайте первый абзац (там главное)
3. Ищите 5-10 ключевых слов
4. Перескажите новость другу

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **4. ТЕХНИКИ ЭФФЕКТИВНОГО ЧТЕНИЯ**

**Техника 1: Skimming (просмотр)**
• Быстро пробегаем глазами
• Ищем общую идею
• Время: 30 секунд на страницу

**Техника 2: Scanning (поиск)**
• Ищем конкретную информацию (даты, имена, цифры)
• Не читаем всё подряд

**Техника 3: Intensive Reading (интенсивное)**
• Читаем медленно и внимательно
• Выписываем новые слова
• Разбираем грамматические конструкции

**Техника 4: Extensive Reading (экстенсивное)**
• Читаем для удовольствия
• Не останавливаемся на каждом слове
• Стараемся понять из контекста

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 **5. РАБОТА С НОВЫМИ СЛОВАМИ**

**Метод 5 шагов для нового слова:**

1. **Увидел** — заметил слово в тексте
2. **Понял из контекста** — попробуй угадать значение
3. **Проверил** — посмотрел в словаре
4. **Записал** — в тетрадь или приложение
5. **Использовал** — составь 3 предложения

**Приложения для словаря:**
• Anki (интервальное повторение)
• Quizlet (карточки и игры)
• LingQ (читает с подсветкой слов)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 **6. ПЛАН ЧТЕНИЯ НА МЕСЯЦ**

**Неделя 1:**
• ПН-ПТ: 10 минут адаптированной книги
• СБ: прочитать короткую новость
• ВС: пересказать прочитанное

**Неделя 2:**
• ПН-ПТ: 15 минут книги
• СБ: статья на знакомую тему
• ВС: выписать 10 новых слов

**Неделя 3:**
• ПН-ПТ: 20 минут
• СБ: найти 5 идиом в тексте
• ВС: написать краткое содержание

**Неделя 4:**
• ПН-ПТ: 25 минут
• СБ: прочитать и обсудить с другом
• ВС: сравнить с русским переводом

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **7. ПРАКТИЧЕСКОЕ ЗАДАНИЕ**

**Сегодняшнее задание:**

1. Найдите текст на 500 слов на сайте News in Levels (уровень 1 или 2)
2. Прочитайте его 3 раза:
   • 1 раз — для общего понимания
   • 2 раз — выпишите 5-7 новых слов
   • 3 раз — перескажите устно

3. Составьте 3 предложения с новыми словами

📌 **Бесплатные ресурсы:**
• readtheory.org — адаптивные тексты с вопросами
• breakingnewsenglish.com — новости по уровням
• english-e-reader.net — бесплатные электронные книги

✨ **Совет:** Читайте то, что вам ИНТЕРЕСНО! Если вы любите спорт — читайте о спорте, если готовить — кулинарные блоги.
        ''';
      case 'Урок 8: Культура и традиции':
        return '''
🌍 **УРОК 8: КУЛЬТУРА И ТРАДИЦИИ АНГЛОЯЗЫЧНЫХ СТРАН**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🇬🇧 **ВЕЛИКОБРИТАНИЯ (UNITED KINGDOM)**

**Самые известные традиции:**

**1. Afternoon Tea (5 o'clock tea)**
• Традиция началась в 1840 году
• Подают: сэндвичи с огурцом, сконы с джемом и кремом
• Этикет: сначала молоко, потом чай
• Интересный факт: 165 миллионов чашек чая выпивают в Британии каждый день!

**2. Guy Fawkes Night (Bonfire Night) — 5 ноября**
• Празднуют провал порохового заговора 1605 года
• Традиции: костры, фейерверки, сжигают чучело Гая Фокса
• Стишок: "Remember, remember the 5th of November..."

**3. Boxing Day — 26 декабря**
• День подарков для слуг и бедных
• Сейчас — главный день распродаж (как наша Черная пятница)
• Традиция: футбольные матчи и охота на лис (сейчас запрещена)

**Британский этикет:**
• Очереди — святое! Никогда не лезьте без очереди
• Говорят "sorry" постоянно (даже если наступили вам на ногу)
• Никогда не спрашивайте "How much do you earn?"
• Чай пьют с молоком, а не с лимоном

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🇺🇸 **СОЕДИНЕННЫЕ ШТАТЫ АМЕРИКИ (USA)**

**Главные праздники:**

**1. Thanksgiving — 4-й четверг ноября**
• История: благодарность за первый урожай пилигримов
• Что едят: индейка (turkey), тыквенный пирог (pumpkin pie), картофельное пюре
• Традиции: парад Macy's в Нью-Йорке, футбол, благодарности за столом
• Интересно: каждый год президент "прощает" одну индейку

**2. Independence Day (4th of July) — День независимости**
• День подписания Декларации независимости (1776)
• Что делают: фейерверки, барбекю, концерты
• Цвета: красный, белый, синий (везде флаги)
• Традиционное блюдо: хот-доги и гамбургеры

**3. Halloween — 31 октября**
• Корни: кельтский праздник Самайн
• Традиции:
  - Trick-or-treat — "сладость или гадость"
  - Jack-o'-lantern — вырезают тыкву со свечой
  - Костюмы монстров и героев
• Статистика: 600 миллионов фунтов конфет продается в США на Halloween!

**4. St. Patrick's Day — 17 марта**
• Ирландский праздник, но празднуют во всей Америке
• Что делают: надевают зеленое, пьют зеленое пиво, парады
• Символы: трилистник (shamrock), лепреконы

**Американские особенности:**
• Чаевые (tips) обязательны: 15-20% в ресторанах
• Очень дружелюбны к незнакомцам: "How are you?" — просто приветствие
• Любят говорить "awesome" и "cool"
• Кофе пьют в огромных стаканах и везде с собой

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🇦🇺 **АВСТРАЛИЯ (AUSTRALIA)**

**Уникальные традиции:**

**1. Australia Day — 26 января**
• День высадки первых британских поселенцев (1788)
• Празднуют: пляжные вечеринки, фейерверки, концерты
• Контроверсия: для аборигенов это "День вторжения"

**2. BBQ культура**
• Австралийцы жарят мясо круглый год (даже на Рождество!)
• "Throw another shrimp on the barbie" — известная фраза
• Обязательное блюдо: сосиски (sausage sizzle)

**3. Melbourne Cup — первый вторник ноября**
• "The race that stops the nation" — гонка, которая останавливает страну
• Все смотрят скачки, даже на работе
• Модный конкурс шляпок для женщин

**Австралийский сленг (Aussie slang):**
| Сленг | Значение | Пример |
|-------|----------|--------|
| G'day | Hello | G'day mate! |
| Arvo | Afternoon | See you this arvo |
| Brekkie | Breakfast | Let's have brekkie |
| Barbie | Barbecue | We're having a barbie |
| Mates | Friends | My mates are here |
| Ta | Thank you | Ta very much! |
| No worries | You're welcome / It's OK | - |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🇨🇦 **КАНАДА (CANADA)**

**Что нужно знать:**

**Праздники:**
• Canada Day (1 июля) — День Канады
• Thanksgiving (2-й понедельник октября) — раньше, чем в США

**Особенности:**
• Двуязычная страна: английский и французский
• Любят говорить "eh?" в конце фразы ("Nice day, eh?")
• Кленовый сироп — национальное сокровище
• Хоккей — национальная религия

**Канадская вежливость:**
• Канадцы извиняются даже за то, что существуют
• Очень пунктуальны
• Помогают незнакомцам (откроют дверь, помогут с картой)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎄 **РОЖДЕСТВО В РАЗНЫХ СТРАНАХ**

| Страна | Особенность |
|--------|-------------|
| Великобритания | Christmas crackers (хлопушки с подарками), королевское обращение в 15:00 |
| США | Santa Claus, milk and cookies, "Elf on the Shelf" |
| Австралия | Пляжное Рождество (+30°C!), барбекю вместо утки |
| Канада | Рождественские парады, ледяные скульптуры |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 **НЕФОРМАЛЬНЫЕ ПРАВИЛА ОБЩЕНИЯ**

**Что можно и нельзя спрашивать:**

**Можно:**
• What do you do for work?
• Where did you grow up?
• Do you have any pets?
• What are your hobbies?

**Нельзя (это личное):**
• How much do you earn?
• How much did your car/house cost?
• Are you married? (в деловой обстановке)
• Why don't you have children?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **ПРАКТИЧЕСКОЕ ЗАДАНИЕ**

1. **Исследование:** Выберите любую англоязычную страну и найдите 5 интересных фактов о ней.

2. **Разговор:** Объясните другу на английском 2 главные традиции этой страны.

3. **Сравнение:** Напишите 5 предложений о том, чем традиции этой страны отличаются от ваших.

4. **Видео:** Найдите на YouTube видео о традициях этой страны (5-10 минут) и запишите 7 новых слов.

🌏 **Бонус:** Посмотрите фильм или сериал из этой страны! (Великобритания — "Love Actually", США — "Home Alone", Австралия — "The Castle")

✨ **Помните:** Знание культуры помогает понимать язык на глубоком уровне. Когда вы знаете WHY говорят ту или иную фразу, учить язык становится намного интереснее!
        ''';
      default:
        return '''
✨ **СОДЕРЖИМОЕ УРОКА СКОРО БУДЕТ ДОБАВЛЕНО**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Мы активно работаем над созданием качественных материалов для всех уроков.

Пожалуйста, зайдите позже!

🎯 **А пока:** Повторите материал предыдущих уроков и выполните практические задания.

Спасибо за понимание и успехов в изучении английского! 💪
        ''';
    }
  }
}