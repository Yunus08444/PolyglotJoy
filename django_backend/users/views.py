from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import LanguageTest, Question, UserStats
from .serializers import UserSerializer, UserRegisterSerializer, UserStatsSerializer
from .test_serializers import LanguageTestSerializer, QuestionSerializer

class UserRegisterView(generics.CreateAPIView):
    serializer_class = UserRegisterSerializer
    permission_classes = [permissions.AllowAny]

class CurrentUserView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user

    def update(self, request, *args, **kwargs):
        user = self.get_object()
        if 'first_name' in request.data:
            user.first_name = request.data['first_name']
        if 'last_name' in request.data:
            user.last_name = request.data['last_name']
        user.save()
        return Response(UserSerializer(user).data)

class LanguageTestListView(generics.ListAPIView):
    queryset = LanguageTest.objects.all()
    serializer_class = LanguageTestSerializer
    permission_classes = [permissions.IsAuthenticated]

class LanguageTestQuestionsView(generics.ListAPIView):
    serializer_class = QuestionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        test_id = self.kwargs.get('test_id')
        return Question.objects.filter(test_id=test_id)

class UserStatsView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        stats, created = UserStats.objects.get_or_create(user=request.user)
        serializer = UserStatsSerializer(stats)
        return Response(serializer.data)

    def post(self, request):
        stats, created = UserStats.objects.get_or_create(user=request.user)
        
        if 'points_earned' in request.data:
            stats.total_points += request.data['points_earned']
        if 'completed_lesson' in request.data and request.data['completed_lesson']:
            stats.completed_lessons += 1
        if 'completed_test' in request.data and request.data['completed_test']:
            stats.completed_tests += 1
        
        stats.save()
        serializer = UserStatsSerializer(stats)
        return Response(serializer.data)

class UserPreferencesView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request):
        stats, created = UserStats.objects.get_or_create(user=request.user)
        
        if 'current_language' in request.data:
            stats.current_language = request.data['current_language']
        if 'learning_language' in request.data:
            stats.learning_language = request.data['learning_language']
        if 'level' in request.data:
            stats.level = request.data['level']
        
        stats.save()
        serializer = UserStatsSerializer(stats)
        return Response(serializer.data)