# PolyglotJoy Django Backend

Минимальный backend для мобильного клиента Flutter.

## Установка

1. Перейти в каталог:

```bash
cd django_backend
```

2. Создать виртуальное окружение и подключить:

```bash
python -m venv .venv
source .venv/Scripts/activate   # Windows
# или
source .venv/bin/activate      # macOS/Linux
```

3. Установить зависимости:

```bash
pip install -r requirements.txt
```

4. Выполнить миграции:

```bash
python manage.py migrate
```

5. Создать суперпользователя (опционально):

```bash
python manage.py createsuperuser
```

6. Запустить сервер:

```bash
python manage.py runserver
```

## Endpoints

- `POST /api/users/` — регистрация (username, email, password)
- `POST /api/token/` — JWT логин (email, password)
- `POST /api/token/refresh/` — обновление токена
- `GET /api/users/me/` — профиль
- `GET /api/tests/` — список тестов
- `GET /api/tests/<test_id>/questions/` — вопросы теста

## Настройка Flutter

В `lib/services/api/api_client.dart` в поле `baseUrl` указать адрес сервера (например `http://10.0.2.2:8000/api`).

`flutter pub get` и `flutter run`.
