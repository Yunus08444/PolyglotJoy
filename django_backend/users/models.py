from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class LanguageTest(models.Model):
    title = models.CharField(max_length=128)
    description = models.TextField(blank=True, default='')
    created_by = models.ForeignKey(User, related_name='tests', on_delete=models.CASCADE)

    def __str__(self):
        return self.title

class Question(models.Model):
    test = models.ForeignKey(LanguageTest, related_name='questions', on_delete=models.CASCADE)
    text = models.TextField()
    answers = models.JSONField(default=list)
    correct_index = models.PositiveIntegerField()

    def __str__(self):
        return f"{self.test.title}: {self.text[:30]}"

class UserStats(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='stats')
    completed_tests = models.IntegerField(default=0)
    completed_lessons = models.IntegerField(default=0)
    total_points = models.IntegerField(default=0)
    streak_days = models.IntegerField(default=0)
    current_language = models.CharField(max_length=50, default='Английский')
    learning_language = models.CharField(max_length=50, default='English')
    level = models.CharField(max_length=50, default='Средний (B1)')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.user.username} - Stats"