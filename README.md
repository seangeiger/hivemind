# hivemind
## A democratic cryptocurrency portfolio.

Created during HackTX 2017 by [benjaminmaccini](https://github.com/benjaminmaccini), [EvanKaminsky](https://github.com/EvanKaminsky), [bkustar](https://github.com/bkustar), [alexdai186](https://github.com/alexdai186), and [seangeiger](https://github.com/seangeiger).

hivemind is an iOS application powered by a django backend that allows a group of users to vote on cryptocurrency investments and collectively make portfolio decisions.  It is currently in papertrading mode.

[INSERT SCREENSHOT HERE]

Each user joins a group with an initial investment.  Every group has a set of cryptocurrency assets that can be traded.  A user sets preferences for each asset:
    
    -BEAR: the user expects the price of the asset to decrease in the future
    -BULL: the user expects the price of the asset to increase in the future
    -BEE: the user has no outlook on the asset or thinks the asset's price will not change
    
Every trading round (adjustable period with a default of 15 minutes), the users' preferences are reviewed.  If a user has not changed their preferences during the trading round, their old preferences will be used.  All user's preferences are weighed proportionally to their stake and an ideal portfolio is constructed.  Trades are executed to adjust the portfolio to this new ideal portfolio.