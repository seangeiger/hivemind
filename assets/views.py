from django.shortcuts import render
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from assets.models import Asset
from assets.serializers import AssetSerializer
from django.http import HttpResponse, JsonResponse


# Create your views here.
@csrf_exempt
@api_view(['GET'])
def asset_list(request):

    if request.method == 'GET':
        assets = Asset.objects.all()
        serializer = AssetSerializer(assets, many=True)
        return JsonResponse(serializer.data, safe=False)
