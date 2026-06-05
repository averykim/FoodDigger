from django.urls import path
from . import views

urlpatterns = [
    path('search-yelp/', views.SearchYelpAPI.as_view(), name='search_yelp'),
    path('history/', views.HistoryAPI.as_view(), name='history_api'),
]