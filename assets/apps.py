from django.apps import AppConfig

class AssetsConfig(AppConfig):
    name = 'assets'
    verbose_name = "Assets Application"
    def ready(self):
        from assets.priceFetcher import updatePrices
        from apscheduler.schedulers.background import BackgroundScheduler
        sched = BackgroundScheduler()
        sched.add_job(updatePrices, 'interval', minutes=1)
        sched.start()