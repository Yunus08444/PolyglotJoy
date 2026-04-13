import random
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import (
    LanguageTest,
    Lesson,
    Question,
    UserLessonCompletion,
    UserLessonExerciseHistory,
    UserProfile,
    UserStats,
)
from .serializers import UserSerializer, UserRegisterSerializer, UserStatsSerializer, LessonSerializer
from .test_serializers import LanguageTestSerializer, QuestionSerializer
from .lesson_content import LESSON_EXERCISES


def get_rotating_lesson_exercises(*, user, lesson, limit):
    exercises = LESSON_EXERCISES.get(lesson.title, [])
    if not exercises:
        return []

    total_count = len(exercises)
    limit = max(1, min(limit, total_count))

    history, _ = UserLessonExerciseHistory.objects.get_or_create(
        user=user,
        lesson=lesson,
        defaults={'seen_indexes': []},
    )

    seen_indexes = [
        index for index in history.seen_indexes
        if isinstance(index, int) and 0 <= index < total_count
    ]
    all_indexes = list(range(total_count))
    unseen_indexes = [index for index in all_indexes if index not in seen_indexes]

    if len(unseen_indexes) >= limit:
        selected_indexes = random.sample(unseen_indexes, limit)
        next_seen_indexes = seen_indexes + selected_indexes
    else:
        selected_indexes = list(unseen_indexes)
        remaining_needed = limit - len(selected_indexes)
        reset_pool = [index for index in all_indexes if index not in selected_indexes]
        random.shuffle(reset_pool)
        carry_over_indexes = reset_pool[:remaining_needed]
        selected_indexes.extend(carry_over_indexes)
        next_seen_indexes = carry_over_indexes

    random.shuffle(selected_indexes)
    history.seen_indexes = next_seen_indexes
    history.save(update_fields=['seen_indexes', 'updated_at'])

    return [exercises[index] for index in selected_indexes]

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

class LessonExercisesView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, lesson_id):
        try:
            lesson = Lesson.objects.get(id=lesson_id)
        except Lesson.DoesNotExist:
            return Response({'error': 'Урок не найден'}, status=status.HTTP_404_NOT_FOUND)

        exercises = LESSON_EXERCISES.get(lesson.title, [])
        if not exercises:
            return Response({'error': 'Для этого урока пока нет упражнений'}, status=status.HTTP_404_NOT_FOUND)

        limit = request.query_params.get('limit')
        try:
            limit = int(limit) if limit is not None else 12
        except ValueError:
            limit = 12

        selected = get_rotating_lesson_exercises(
            user=request.user,
            lesson=lesson,
            limit=limit,
        )

        return Response(selected)


class LanguageTestListView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        queryset = LanguageTest.objects.filter(questions__isnull=False).distinct()
        if queryset.exists():
            serializer = LanguageTestSerializer(queryset, many=True)
            return Response(serializer.data)

        fallback_tests = []
        for lesson in Lesson.objects.all():
            exercises = LESSON_EXERCISES.get(lesson.title, [])
            if exercises:
                fallback_tests.append({
                    'id': lesson.id,
                    'title': lesson.title,
                    'description': lesson.subtitle or lesson.description,
                    'questions_count': len(exercises),
                })

        return Response(fallback_tests)


class LanguageTestQuestionsView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, test_id):
        queryset = Question.objects.filter(test_id=test_id)
        if queryset.exists():
            questions = list(queryset)
            random.shuffle(questions)
            serializer = QuestionSerializer(questions, many=True)
            return Response(serializer.data)

        lesson = Lesson.objects.filter(id=test_id).first()
        if lesson is None:
            return Response({'error': 'Тест не найден'}, status=status.HTTP_404_NOT_FOUND)

        exercises = LESSON_EXERCISES.get(lesson.title, [])
        if not exercises:
            return Response({'error': 'Для этого теста пока нет вопросов'}, status=status.HTTP_404_NOT_FOUND)

        selected_exercises = get_rotating_lesson_exercises(
            user=request.user,
            lesson=lesson,
            limit=len(exercises),
        )

        questions = []
        for index, exercise in enumerate(selected_exercises, start=1):
            answers = list(exercise.get('options', []))
            answer = exercise.get('answer')
            try:
                correct_index = answers.index(answer)
            except ValueError:
                correct_index = 0

            questions.append({
                'id': index,
                'text': exercise.get('question', ''),
                'answers': answers,
                'correct_index': correct_index,
            })

        return Response(questions)

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
