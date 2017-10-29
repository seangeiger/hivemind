from assets.models import Asset
from portfolio.models import Portfolio, Position
from django.core.management.base import BaseCommand, CommandError

class Command(BaseCommand):
    help = 'Creates Portfolio'

    def add_arguments(self, parser):
        pass

    def handle(self, *args, **options):
        port_folio = Portfolio(id = 0)
        port_folio.save()

        for a in Asset.objects.all():
            pos = Position(asset = a,portfolio=port_folio, assetAmount=0,portfolioPercentage=0)
            pos.save()