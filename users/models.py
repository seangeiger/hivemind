from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver
from assets.models import Asset
from rest_framework.authtoken.models import Token
from portfolio.models import Portfolio


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    total_investment = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    original_investment = models.DecimalField(max_digits=15, decimal_places=2, default = 0)
    transfer_request = models.DecimalField(max_digits = 15, decimal_places = 2, default = 0)
    not_invested = models.BooleanField(default=True)

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        profile = Profile.objects.create(user=instance)
        profile.save()
        profile.refresh_from_db()
        Token.objects.get_or_create(user=instance)
        # Create all preferences
        for asset in Asset.objects.all():
            pref = Preference(asset=asset, user=instance, preference=Preference.BEE)
            pref.save()
        if instance.not_invested and instance.original_investment > 0:
            portfolio = Portfolio.objects.get()
            portfolio.uninvested += instance.original_investment
            portfolio.save()
            instance.not_invested = False
            instance.save()

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()

@receiver(post_save, sender=Profile)
def calculated_uninvested(sender, instance, **kwargs):
    if instance.not_invested and instance.original_investment > 0:
        portfolio = Portfolio.objects.get()
        portfolio.uninvested += instance.original_investment
        portfolio.save()
        instance.not_invested = False
        instance.save()

class Preference(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    BULL = 'BULL'
    BEAR = 'BEAR'
    BEE = 'BEE'
    PREF_CHOICES = (
        (BULL, 'Bull'),
        (BEAR, 'Bear'),
        (BEE, 'Bee'),
    )
    preference = models.CharField(max_length=5, choices=PREF_CHOICES, blank=False, default=BEE)

    asset = models.ForeignKey(Asset, on_delete=models.CASCADE)
