from rest_framework import serializers
from assets.models import Asset


class AssetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Asset
        fields = ('name', 'price', 'api_name',)
