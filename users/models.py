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
    original_investment = models.DecimalField(max_digits=15, decimal_places=2)


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        # profile = Profile.objects.create(user=instance)
        # profile.total_investment = profile.original_investment
        # profile.save()
        Token.objects.create(user=instance)
        portfolio = Portfolio.objects.get()
        portfolio.uninvested += profile.original_investment
        portfolio.save()

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()


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
