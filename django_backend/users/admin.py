from django.contrib import admin
from django.contrib.auth import get_user_model
from .models import LanguageTest, Question, UserStats

User = get_user_model()

try:
    admin.site.unregister(User)
except admin.sites.NotRegistered:
    pass

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('id', 'username', 'email', 'first_name', 'last_name', 'is_staff', 'is_active')
    list_filter = ('is_staff', 'is_superuser', 'is_active')
    search_fields = ('username', 'email', 'first_name', 'last_name')

@admin.register(LanguageTest)
class LanguageTestAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'created_by')
    search_fields = ('title',)

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'test', 'text')
    search_fields = ('text',)

@admin.register(UserStats)
class UserStatsAdmin(admin.ModelAdmin):
    list_display = ('user', 'completed_tests', 'completed_lessons', 'total_points', 'streak_days')
    search_fields = ('user__username',)