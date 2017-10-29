from portfolio.models import Portfolio, Position
from rest_framework import serializers

class PortfolioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Portfolio
        fields = ('total_investment', 'uninvested',)

class PositionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Position
        fields = ('assetAmount', 'asset', 'portfolio',)
