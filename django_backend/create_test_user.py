import os
import django
import random

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from django.contrib.auth.models import User

username = f"testuser_{random.randint(100000, 999999)}"
email = f"{username}@test.com"
password = "TestPassword123"

try:
    user = User.objects.create_user(username=username, email=email, password=password)
    print(f"✅ Пользователь создан:")
    print(f"   Username: {username}")
    print(f"   Email: {email}")
    print(f"   Password: {password}")
except Exception as e:
    print(f"❌ Ошибка: {e}")
