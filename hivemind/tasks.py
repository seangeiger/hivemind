from assets.models import Asset
from portfolio.models import Portfolio, Position
from django.core.management.base import BaseCommand, CommandError
from portfolio.portfolio import computePortfolioUpdate
from assets.priceFetcher import updatePrices
from apscheduler.schedulers.background import BackgroundScheduler
def schedule():
    sched = BackgroundScheduler()
    #Change to 15 mins
    sched.add_job(computePortfolioUpdate, 'interval', minutes=.5)
    sched.add_job(updatePrices, 'interval', minutes=1)
    sched.start()