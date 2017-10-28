from apscheduler.schedulers.background import BackgroundScheduler
sched = BackgroundScheduler()
#sched.add_job(sync_canvas_progress, 'interval', minutes=10)
sched.start()