from django.contrib import admin
from django.contrib.auth import get_user_model
from .models import LanguageTest, Question, UserLessonExerciseHistory, UserStats, UserProfile

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

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'photo', 'created_at', 'updated_at')
    search_fields = ('user__username',)
    readonly_fields = ('created_at', 'updated_at')

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


@admin.register(UserLessonExerciseHistory)
class UserLessonExerciseHistoryAdmin(admin.ModelAdmin):
    list_display = ('user', 'lesson', 'updated_at')
    search_fields = ('user__username', 'lesson__title')
    readonly_fields = ('updated_at',)
