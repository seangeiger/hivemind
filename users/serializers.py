from users.models import Profile, Preference
from rest_framework import serializers
from assets.serializers import AssetSerializer
from django.contrib.auth.models import User


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile

        fields = ('total_investment', 'original_investment', 'transfer_request',)
        read_only_fields = ('total_investment',)


class PreferenceSerializer(serializers.ModelSerializer):
    asset = AssetSerializer(read_only=True)

    class Meta:
        model = Preference
        fields = ('preference', 'asset', )

    def update(self, instance, validated_data):
        instance.preference = validated_data.get('preference', instance.preference)
        instance.save()
        return instance


class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer()

    class Meta:
        model = User
        fields = ('username', 'password', 'profile', )

    def create(self, validated_data):
        user = User.objects.create(
            username=validated_data['username'],
            password=validated_data['password'],
        )
        user.save()
        user.set_password(validated_data['password'])
        user.save()
        user.refresh_from_db()
        user.profile.original_investment = validated_data['profile']['original_investment']
        user.profile.save()

        return user
