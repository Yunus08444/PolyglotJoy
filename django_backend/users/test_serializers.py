from rest_framework import serializers
from .models import LanguageTest, Question

class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = ('id', 'text', 'answers', 'correct_index')

class LanguageTestSerializer(serializers.ModelSerializer):
    questions_count = serializers.IntegerField(source='questions.count', read_only=True)

    class Meta:
        model = LanguageTest
        fields = ('id', 'title', 'description', 'questions_count')
