#Fetches current price of select coin in reference to USD
import krakenex
import datetime
from assets.models import Asset
def updatePrices():

    assets = Asset.objects.all()

    k = krakenex.API()

    for a in assets:
        a.price = getPrice(k,a.api_name)
        a.save()

def getPrice(k,coin = 'XXBTZUSD'):
    results = k.query_public("Ticker",{'pair':coin})['result'][coin]
    return eval(results['a'][0])