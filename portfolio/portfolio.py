
from users.models import Preference
from assets.models import Asset
from portfolio.models import Portfolio
from portfolio.models import Position
from django.contrib.auth.models import User

def computePortfolioUpdate():
    users = User.objects.all()
    assets = Asset.objects.all()
    portfolio = Portfolio.objects.get()
    positions = Position.objects.all()

    totalInvestment = 0.0
    for u in users:
        totalInvestment += u.totalinvestments

    currentAssetInvestments = {p.asset : p.asset.price * p.assetAmount for p in positions}

    portfolioValue = computePortfolioValue(portfolio)

    assetDecisions = {ass : computeAssetDecision(ass, users, totalInvestment) for ass in assets}
    totalAssetDecisions = 0
    for ass in assetDecisions:
        if assetDecisions[ass] > 0:
            totalAssetDecisions += assetDecisions[ass]
    if totalAssetDecisions == 0:
        #pull out
        desiredAssetInvestments = {ass : 0 for ass in assetDecisions}
    else:
        for ass in assetDecisions:
            assetDecisions[ass] = assetDecisions[ass]/totalAssetDecisions
            if assetDecisions[ass] < 0:
                assetDecisions[ass] = 0
        desiredAssetInvestments = {ass : assetDecisions[ass] * portfolioValue for ass in assetDecisions}

        assetValueChanges = {}


    


def computeAssetDecision(asset, users, totalInvestment):
    totalVote = 0
    for u in users:
        weight = u.profile.total_investment / totalInvestment
        vote = "BEE"
        preferences = Preference.objects.filter(user=u)
        for p in preferences:
            if p.asset == asset:
                vote = p.preference
                break
        if vote == Preference.BULL:
            totalVote += weight
        if vote == Preference.BEAR:
            totalVote -= weight

    return totalVote

def computePortfolioValue(portfolio):
    #multiply asset values by asset amounts