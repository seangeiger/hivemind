from django.db import models

# Create your models here.

class Portfolio(models.Model):
	totalInvestment = models.DecimalField(max_digits = 15, decimal_places = 2)

class Position(models.Model):
	portfolio = models.ForeignKey(Portfolio, on_delete=models.CASCADE)
	assetAmount = models.DecimalField(max_digits = 20, decimal_places = 8)
	portfolioPercentage = models.DecimalField(max_digits = 11, decimal_places = 8)
