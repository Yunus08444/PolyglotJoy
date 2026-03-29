from django.contrib.auth import get_user_model
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class EmailTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        username_value = attrs.get('username')
        if username_value and '@' in username_value:
            User = get_user_model()
            try:
                user = User.objects.get(email__iexact=username_value)
                attrs['username'] = user.get_username()
            except User.DoesNotExist:
                pass
        return super().validate(attrs)

class EmailTokenObtainPairView(TokenObtainPairView):
    serializer_class = EmailTokenObtainPairSerializer