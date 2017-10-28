from apscheduler.schedulers.background import BackgroundScheduler
from assets.priceFetcher import updatePrices
sched = BackgroundScheduler()
sched.add_job(updatePrices, 'interval', minutes=5)
sched.start()