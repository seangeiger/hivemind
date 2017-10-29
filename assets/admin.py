from django.contrib import admin
from assets.models import Asset

class AssetAdmin(admin.ModelAdmin):
    pass
admin.site.register(Asset, AssetAdmin)