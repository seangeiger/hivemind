from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from portfolio.models import Position, Portfolio
from portfolio.serializers import PositionSerializer
from assets.models import Asset
from rest_framework.decorators import api_view
# Create your views here.


@csrf_exempt
@api_view(['GET','PUT'])
def position_list(request):

    if request.method == 'GET':
        port_folio = Portfolio.objects.get()
        pos = Position.objects.all(portfolio = port_folio)
        serializer = PositionSerializer(pos, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        try:
            asset = Asset.objects.get(api_name=data['asset']['api_name'])
            pos = Position.objects.get(user=request.user, asset=asset)
        except Position.DoesNotExist:
            return JsonResponse("", status=400)
        serializer = PositionSerializer(pos, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=200)
        return JsonResponse(serializer.errors, status=400)
