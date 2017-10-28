from django.db import models

# Create your models here.
class Asset(models.Model):
    name = models.CharField(max_length = 10)
    price = models.DecimalField(max_digits=15,decimal_places=8)
    api_name = models.CharField(max_length = 10)