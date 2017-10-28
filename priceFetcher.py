#Fetches current price of select coin in reference to USD
import krakenex
import datetime

loc = ['XXBTZUSD',]

def getPrice(coin = 'XXBTZUSD'):
    k = krakenex.API()
    results = k.query_public("Ticker",{'pair':coin})['result'][coin]
    return eval(results['a'][0])
