from django.apps import AppConfig

class PortfolioConfig(AppConfig):
    name = 'portfolio'
    verbose_name = "Portfolio Application"
    is_ready = False

    def ready(self):
        from portfolio.models import Portfolio
        if(Portfolio.objects.all() != None and not self.is_ready):
            self.is_ready =True
            port_folio = Portfolio(id=0)
            port_folio.save()
        else:
            print("Portfolio object already exists")
