from rest_framework import serializers
from assets.models import Asset
from users.models import Preference


class AssetSerializer(serializers.ModelSerializer):
    bee_value = serializers.SerializerMethodField()

    def get_bee_value(self, obj):
        prefs = Preference.objects.filter(asset=obj)
        value = 0
        total = 0
        for pref in prefs:
            amount = pref.user.profile.total_investment
            total += amount
            if pref.preference == pref.BULL:
                value += amount
            elif pref.preference == pref.BEAR:
                value -= amount
        if total != 0:
            value /= total * 100
        return float(value)

    class Meta:
        model = Asset
        fields = ('name', 'price', 'api_name', 'bee_value',)
