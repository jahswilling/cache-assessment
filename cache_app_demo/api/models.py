from django.db import models
import uuid

class HealthCheck(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    timestamp = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=50, default='healthy')
    message = models.TextField(blank=True)

    def __str__(self):
        return f"{self.status} at {self.timestamp}"