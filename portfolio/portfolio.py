
from users.models import Preference
from assets.models import Asset
from portfolio.models import Portfolio
from portfolio.models import Position
from django.contrib.auth.models import User

def computePortfolioUpdate():
    print("Updating portfolio...\n")
    users = User.objects.all()
    assets = Asset.objects.all()
    portfolio = Portfolio.objects.get()
    positions = Position.objects.all()

    currentAssetInvestments = {p.asset : p.asset.price * p.assetAmount for p in positions}

    portfolioValueInvested = computePortfolioInvestedValue(portfolio, positions)
    portfolioValueTotal = portfolioValueInvested + portfolio.uninvested

    totalNetTransfers = updateProfileInvestmentValues(portfolio, users, portfolioValueInvested, portfolioValueTotal)
    portfolioValueTotal+=totalNetTransfers
    for u in users:
        u.refresh_from_db()

    assetDecisions = {ass : computeAssetDecision(ass, users, portfolioValueTotal) for ass in assets}
    totalAssetDecisions = 0
    for ass in assetDecisions:
        if assetDecisions[ass] > 0:
            totalAssetDecisions += assetDecisions[ass]
    if totalAssetDecisions == 0:
        #pull out
        assetValueChanges = {ass : currentAssetInvestments[ass] * -1 for ass in assets}
        desiredAssetInvestments = {ass : 0 for ass in assets}
    else:
        for ass in assetDecisions:
            assetDecisions[ass] = assetDecisions[ass]/totalAssetDecisions
            if assetDecisions[ass] < 0:
                assetDecisions[ass] = 0
        desiredAssetInvestments = {ass : assetDecisions[ass] * portfolioValueTotal for ass in assets}

        assetValueChanges = {ass : desiredAssetInvestments[ass] - currentAssetInvestments[ass] for ass in assets}

    updatePortfolioTotalInvestment(portfolio, desiredAssetInvestments, portfolioValueTotal)
    updatePositions(positions, desiredAssetInvestments)
    return assetValueChanges

def computeAssetDecision(asset, users, totalInvestment):
    totalVote = 0
    for u in users:
        if(totalInvestment == 0):
            for u in users:
                totalInvestment += u.profile.total_investment
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

def computePortfolioInvestedValue(portfolio, positions):
    totalInvestment = 0
    for p in positions:
        totalInvestment += p.assetAmount * p.asset.price
    return totalInvestment


def updatePortfolioTotalInvestment(portfolio, desiredInvestments, newTotalValue):
    totalInvestment = 0
    for a in desiredInvestments:
        totalInvestment += desiredInvestments[a]
    portfolio.totalInvestment = totalInvestment
    if totalInvestment == 0:
        portfolio.uninvested = newTotalValue
    else:
        portfolio.uninvested = 0
    portfolio.save()


def updateProfileInvestmentValues(portfolio, users, newInvested, newTotal):
    previousInvestment = portfolio.totalInvestment
    totalNetTransfers = 0
    if(previousInvestment == 0):
        for u in users:
            if u.profile.total_investment == 0:
                if u.profile.transfer_request > 0:
                    u.profile.original_investment += u.profile.transfer_request
                u.profile.total_investment = u.profile.original_investment
                totalNetTransfers += u.profile.transfer_request
                u.save()
        return totalNetTransfers
    for u in users:
        investmentPercentage = u.profile.total_investment / previousInvestment
        u.profile.total_investment = investmentPercentage*newTotal
        if u.profile.transfer_request > 0:
            totalNetTransfers += u.profile.transfer_request
            u.profile.total_investment += u.profile.transfer_request
            u.profile.transfer_request = 0
        else:
            if u.profile.transfer_request > (-1 * u.profile.total_investment):
                totalNetTransfers += u.profile.transfer_request
                u.profile.total_investment += u.profile.transfer_request
                u.profile.transfer_request = 0
            else:
                transfer_val = -1 * u.profile.total_investment
                totalNetTransfers += transfer_val
                u.profile.total_investment += transfer_val
                u.profile.transfer_request = 0
        if investmentPercentage == 0:
            u.profile.total_investment = u.profile.original_investment
        u.save()

    return totalNetTransfers

def updatePositions(positions, desiredInvestments):
    totalInvestment = 0
    for a in desiredInvestments:
        totalInvestment += desiredInvestments[a]

    for p in positions:
        desiredValue = desiredInvestments[p.asset]
        desiredAmount = desiredValue / p.asset.price
        p.assetAmount = desiredAmount

        p.portfolioPercentage = desiredValue/totalInvestment if totalInvestment>0 else 0
        p.save()