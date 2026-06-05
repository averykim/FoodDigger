from rest_framework import serializers
from .models import History

class HistorySerializer(serializers.ModelSerializer):
    yelp_id = serializers.CharField(required=False, allow_null=True, allow_blank=True)
    class Meta:
        model = History

        fields = ['id', 'yelp_id', 'is_custom', 'restaurant_name', 'image_url', 'rating', 'address', 'created_at']
        read_only_fields = ['id', 'created_at']
    
    def validate(self, data):
        is_custom = data.get('is_custom', False)
        yelp_id = data.get('yelp_id')

        if not is_custom and not yelp_id:
            raise serializers.ValidationError({"yelp_id": "yelp_id is required to save restaurant from Yelp."})
        
        if is_custom and yelp_id:
            data['yelp_id'] = None

        return data