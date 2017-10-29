#Fetches current price of select coin in reference to USD
import krakenex
import datetime
from background_task import background
from assets.models import Asset


def getPrice(k,coin = 'XXBTZUSD'):
    results = k.query_public("Ticker",{'pair':coin})['result'][coin]
    return eval(results['a'][0])


@background(schedule=0, repeat=60)
def updatePrices():
    print("Updating prices")

    assets = Asset.objects.all()

    k = krakenex.API()

    for a in assets:
        a.price = getPrice(k,a.api_name)
        print(a.api_name,a.price)
        a.save()


updatePrices()