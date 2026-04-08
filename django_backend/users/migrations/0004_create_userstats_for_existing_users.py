from django.db import migrations

def create_stats_for_existing_users(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    UserStats = apps.get_model('users', 'UserStats')

    for user in User.objects.all():
        UserStats.objects.get_or_create(user=user)
    print(f"✅ Created UserStats for {User.objects.count()} users")

def reverse(apps, schema_editor):
    pass

class Migration(migrations.Migration):

    dependencies = [
        ('users', '0003_userprofile'),
    ]

    operations = [
        migrations.RunPython(create_stats_for_existing_users, reverse),
    ]


