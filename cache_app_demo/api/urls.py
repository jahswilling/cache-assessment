from django.urls import path
from . import views

urlpatterns = [
    path('health/', views.health_check, name='health_check'),
    path('messages/', views.get_messages, name='get_messages'),
]