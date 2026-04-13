from django.urls import path
from .views import (
    UserRegisterView,
    CurrentUserView,
    LanguageTestListView,
    LanguageTestQuestionsView,
    UserStatsView,
    UserPreferencesView,
    LessonListView,
    LessonCompleteView,
    LessonExercisesView,
)

urlpatterns = [
    path('users/', UserRegisterView.as_view(), name='user-register'),
    path('users/me/', CurrentUserView.as_view(), name='user-me'),
    path('users/me/stats/', UserStatsView.as_view(), name='user-stats'),
    path('users/me/preferences/', UserPreferencesView.as_view(), name='user-preferences'),
    path('lessons/', LessonListView.as_view(), name='lesson-list'),
    path('lessons/<int:lesson_id>/exercises/', LessonExercisesView.as_view(), name='lesson-exercises'),
    path('lessons/<int:lesson_id>/complete/', LessonCompleteView.as_view(), name='lesson-complete'),
    path('tests/', LanguageTestListView.as_view(), name='test-list'),
    path('tests/<int:test_id>/questions/', LanguageTestQuestionsView.as_view(), name='test-questions'),
]
