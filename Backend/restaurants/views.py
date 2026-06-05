from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.utils import timezone
from django.shortcuts import get_object_or_404
from datetime import timedelta
from .models import History
from .serializers import HistorySerializer
import requests
import os
from dotenv import load_dotenv

load_dotenv()
    
class SearchYelpAPI(APIView):
    
    permission_classes = [AllowAny]

    def get(self, request):
        lat = request.query_params.get('latitude')
        lon = request.query_params.get('longitude')
        category = request.query_params.get('category')

        if not lat or not lon:
            return Response({"error": "No latitude and longitude"}, status=400)

        yelp_url = "https://api.yelp.com/v3/businesses/search"
        YELP_KEY = os.environ.get('YELP_API_KEY')
        headers = {
            "Authorization": "Bearer {YELP_KEY}",
            "accept": "application/json"
        }
        params = {
            "categories": category,
            "latitude": lat,
            "longitude": lon,
            "term": "restaurant",
            "limit": 10
        }
        response = requests.get(yelp_url, headers=headers, params=params)

        if response.status_code != 200:
            return Response({"error:": "Fail to call Yelp API"}, status=response.status_code)
        
        yelp_data = response.json()
        
        businesses = yelp_data.get('businesses', [])
        clean_results = []
        for b in businesses:
            clean_results.append({
                "yelp_id": b.get("id"),
                "name": b.get("name"),
                "image_url": b.get("image_url"),
                "rating": b.get("rating"),
                "address": " ".join(b.get("location", {}).get("display_address", [])),
                "latitude": b.get("coordinates", {}).get("latitude"),
                "longitude": b.get("coordinates", {}).get("longitude")
            })

        if request.user.is_authenticated and clean_results:
            yelp_ids = [biz['yelp_id'] for biz in clean_results]
            histories = History.objects.filter(user=request.user, yelp_id__in=yelp_ids).values('yelp_id', 'id')
            saved_map = { item['yelp_id']: item['id'] for item in histories}
            for b in clean_results:
                biz_id = b['yelp_id']
                if biz_id in saved_map:
                    b['is_saved'] = True
                    b['history_id'] = saved_map[biz_id]
                else:
                    b['is_saved'] = False
                    b['history_id'] = None
            return Response({"results": clean_results})
        
        return Response({"results": clean_results})

class HistoryAPI(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        histories = History.objects.filter(user=request.user).order_by('-created_at')
        serializer = HistorySerializer(histories, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
       serializer = HistorySerializer(data=request.data)
       if serializer.is_valid():
        yelp_id = serializer.validated_data.get('yelp_id')
        is_custom = serializer.validated_data.get('is_custom', False)

        if not is_custom and yelp_id:
            if History.objects.filter(user=request.user, yelp_id=yelp_id).exists():
                return Response({"error": "Restaurant already exists."}, status=status.HTTP_400_BAD_REQUEST)
        serializer.save(user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

       return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request):
        yelp_id = request.query_params.get('yelp_id') or request.data.get('yelp_id')
        history_id = request.query_params.get('id') or request.data.get('id')

        try:
            if yelp_id:
                history = History.objects.get(user=request.user, yelp_id=yelp_id)
            elif history_id:
                history = History.objects.get(user=request.user, id=history_id)
            else:
                return Response({"error": "For deleting restaurant, id or yelp_id is required."}, status=status.HTTP_400_BAD_REQUEST)
            history.delete()
            return Response({"message": "Deleted"}, status=status.HTTP_200_OK)
        except History.DoesNotExist:
            return Response({"error": "Cannot find the restaurant."}, status=status.HTTP_404_NOT_FOUND)

