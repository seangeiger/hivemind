#Fetches current price of select coin in reference to USD
import krakenex
import time
from assets.models import Asset


def getPrice(k,coin = 'XXBTZUSD'):
    results = k.query_public("Ticker",{'pair':coin})['result'][coin]
    return eval(results['a'][0])

def updatePrices():

    assets = Asset.objects.all()

    k = krakenex.API()

    for a in assets:
        print("Sleeping...")
        time.sleep(5)
        a.price = getPrice(k,a.api_name)
        print(a.api_name,a.price)
        a.save()