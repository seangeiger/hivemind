from portfolio.models import Portfolio, Position
from rest_framework import serializers
from assets.serializers import AssetSerializer

class PortfolioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Portfolio
        fields = ('total_investment', 'uninvested',)

class PositionSerializer(serializers.ModelSerializer):
    asset = AssetSerializer(read_only=True)
    portfolio = PortfolioSerializer(read_only=True)
    class Meta:
        model = Position
        fields = ('assetAmount', 'asset', 'portfolioPercentage', 'portfolio',)
