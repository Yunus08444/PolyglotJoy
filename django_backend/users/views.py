from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import LanguageTest, Question, UserStats, UserProfile, Lesson, UserLessonCompletion
from .serializers import UserSerializer, UserRegisterSerializer, UserStatsSerializer, LessonSerializer
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

        # Handle photo upload
        if 'photo' in request.FILES:
            profile, created = UserProfile.objects.get_or_create(user=user)
            profile.photo = request.FILES['photo']
            profile.save()

        return Response(UserSerializer(user, context={'request': request}).data)

class LessonListView(generics.ListAPIView):
    queryset = Lesson.objects.all()
    serializer_class = LessonSerializer
    permission_classes = [permissions.IsAuthenticated]

class LessonCompleteView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, lesson_id):
        try:
            lesson = Lesson.objects.get(id=lesson_id)
        except Lesson.DoesNotExist:
            return Response({'error': 'Урок не найден'}, status=status.HTTP_404_NOT_FOUND)

        completion, created = UserLessonCompletion.objects.get_or_create(
            user=request.user,
            lesson=lesson
        )

        if created:
            stats = UserStats.objects.get(user=request.user)
            stats.completed_lessons += 1
            stats.save()

        return Response({'completed': True, 'lesson': LessonSerializer(lesson, context={'request': request}).data})

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
        print(f'\n🔍 Getting stats for user: {request.user.username}')
        stats, created = UserStats.objects.get_or_create(user=request.user)
        print(f'   Created: {created}')
        print(f'   Stats object: id={stats.id}')
        print(f'   completed_tests={stats.completed_tests}, completed_lessons={stats.completed_lessons}')
        print(f'   total_points={stats.total_points}, streak_days={stats.streak_days}')
        print(f'   current_language={stats.current_language}, level={stats.level}')
        serializer = UserStatsSerializer(stats)
        print(f'   Serialized data: {serializer.data}\n')
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