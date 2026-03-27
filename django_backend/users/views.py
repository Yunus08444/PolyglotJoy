from rest_framework import generics, permissions
from .models import LanguageTest, Question
from .serializers import UserSerializer, UserRegisterSerializer
from .test_serializers import LanguageTestSerializer, QuestionSerializer

class UserRegisterView(generics.CreateAPIView):
    serializer_class = UserRegisterSerializer
    permission_classes = [permissions.AllowAny]

class CurrentUserView(generics.RetrieveAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user

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
