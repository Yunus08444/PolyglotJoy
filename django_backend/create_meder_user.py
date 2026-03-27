import os
import django
import random

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from django.contrib.auth.models import User

username = f"meder_{random.randint(1000, 9999)}"
email = f"{username}@test.com"
first_name = "Медер"
last_name = "Тестов"
password = "TestPassword123"

try:
    user = User.objects.create_user(
        username=username,
        email=email,
        password=password,
        first_name=first_name,
        last_name=last_name
    )
    print(f"✅ Пользователь создан:")
    print(f"   Username: {username}")
    print(f"   Email: {email}")
    print(f"   Имя: {first_name} {last_name}")
    print(f"   Password: {password}")
except Exception as e:
    print(f"❌ Ошибка: {e}")
