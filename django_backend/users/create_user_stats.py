import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from django.contrib.auth.models import User
from users.models import UserStats

def create_stats_for_all_users():
    users = User.objects.all()
    for user in users:
        stats, created = UserStats.objects.get_or_create(user=user)
        if created:
            print(f"✅ Создана статистика для {user.username}")
        else:
            print(f"⏩ Статистика уже есть у {user.username}")

if __name__ == '__main__':
    create_stats_for_all_users()