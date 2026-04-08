from django.contrib.auth import get_user_model
from rest_framework import serializers
from .models import UserStats, UserProfile, Lesson, UserLessonCompletion

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    photo = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 'photo')

    def get_photo(self, obj):
        try:
            profile = obj.profile
            if profile.photo:
                request = self.context.get('request')
                if request:
                    return request.build_absolute_uri(profile.photo.url)
                return profile.photo.url
        except UserProfile.DoesNotExist:
            pass
        return None

class UserRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'first_name', 'last_name')

    def validate_email(self, value):
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError("Пользователь с таким email уже существует.")
        return value

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
        )
        UserStats.objects.create(user=user)
        UserProfile.objects.create(user=user)
        return user

class LessonSerializer(serializers.ModelSerializer):
    is_completed = serializers.SerializerMethodField()

    class Meta:
        model = Lesson
        fields = ('id', 'title', 'subtitle', 'description', 'order', 'is_completed')

    def get_is_completed(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return UserLessonCompletion.objects.filter(
                user=request.user,
                lesson=obj
            ).exists()
        return False

class UserStatsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserStats
        fields = (
            'completed_tests', 'completed_lessons', 'total_points',
            'streak_days', 'current_language', 'level'
        )