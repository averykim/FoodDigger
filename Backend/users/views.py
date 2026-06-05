from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from .serializers import UserSerializer, CustomTokenObtainPairSerializer, PasswordResetSerializer, ChangePasswordSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.exceptions import TokenError
from django.core.mail import send_mail
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth import get_user_model

User = get_user_model()

class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Register Success"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({"username": user.username, "email": user.email}, status=status.HTTP_200_OK)

class ResetPasswordView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get("email")
        serializer = PasswordResetSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            user = User.objects.get(email=email)
        
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            token = default_token_generator.make_token(user)

            reset_link = f"http://127.0.0.1:8000/users/reset-password/{uid}/{token}/"

            try:
                send_mail(
                    subject = "[FoodDigger] Password Reset Request",
                    message = f"Hello,\n\nClick the link below to reset your password:\n\n {reset_link}\n\nIf you didn't request this, please ignore this email.",
                    from_email = "noreply@fooddigger.com",
                    recipient_list = [email],
                    fail_silently = False,
                    )
                
                return Response({"message": "A password reset link has been sent to your email."}, 
                                status=status.HTTP_200_OK)
            except Exception as e:
                print(f"Email sending failed: {e}")
                return Response({"error": "Fail to send email."}, 
                                status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)
        if serializer.is_valid():

            old_password = request.data.get('old_password')
            new_password = request.data.get('new_password')

            # Get current requested user's object using token
            user = request.user

            if not user.check_password(old_password):
                return Response({"error": "The current password does not match."}, status=status.HTTP_400_BAD_REQUEST)

            if old_password == new_password:
                return Response({"error": "Your new password must be different from your current password."}, status=status.HTTP_400_BAD_REQUEST)

            try:
                user.set_password(new_password)
                user.save()
                return Response({"message": "Your password has been successfully changed."})
            except Exception as e:
                print(f"Database save failed: {e}")
                return Response({"error": "A server error occurred while saving the password."}, 
                                status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get("refresh")

            if not refresh_token:
                return Response({"error": "Refresh token is required"}, 
                                status=status.HTTP_400_BAD_REQUEST)
            
            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response({"message": "Successfully logged out."}, 
                            status=status.HTTP_205_RESET_CONTENT)
        except TokenError:
            return Response({"error": "Token is invalid or expired."}, 
                            status=status.HTTP_400_BAD_REQUEST)