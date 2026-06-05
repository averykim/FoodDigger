from django.db import models
from django.contrib.auth import get_user_model
    
User = get_user_model()

class History(models.Model):
    user = models.ForeignKey(User,
                             on_delete=models.CASCADE,
                             related_name='histories')
    yelp_id = models.CharField(max_length=255, null=True, blank=True)
    is_custom = models.BooleanField(default=False)
    restaurant_name = models.CharField(max_length=255)
    image_url = models.URLField(blank=True, null=True)
    rating = models.FloatField(default=0.0)
    address = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['user', 'yelp_id'],
                                    name='unique_user_saved_restaurant',
                                    condition=models.Q(yelp_id__isnull=False))
        ]

    def __str__(self):
        return f"{self.user.username} visited {self.restaurant_name}"