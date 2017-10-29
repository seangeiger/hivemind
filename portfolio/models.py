from django.db import models
from assets.models import Asset


# Create your models here.

class Portfolio(models.Model):
	totalInvestment = models.DecimalField(max_digits = 15, decimal_places = 2, default = 0)
	uninvested = models.DecimalField(max_digits = 15, decimal_places = 2, default = 0)

class Position(models.Model):
	portfolio = models.ForeignKey(Portfolio, on_delete=models.CASCADE)
	assetAmount = models.DecimalField(max_digits = 20, decimal_places = 8)
	asset = models.ForeignKey(Asset, on_delete=models.CASCADE)
	portfolioPercentage = models.DecimalField(max_digits = 11, decimal_places = 8)
