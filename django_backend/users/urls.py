from django.urls import path
from .views import (
    UserRegisterView,
    CurrentUserView,
    LanguageTestListView,
    LanguageTestQuestionsView,
)

urlpatterns = [
    path('users/', UserRegisterView.as_view(), name='user-register'),
    path('users/me/', CurrentUserView.as_view(), name='user-me'),
    path('tests/', LanguageTestListView.as_view(), name='test-list'),
    path('tests/<int:test_id>/questions/', LanguageTestQuestionsView.as_view(), name='test-questions'),
]
